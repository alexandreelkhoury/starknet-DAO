#[starknet::component]
mod Erc20Component { // nom du contract
    use starknet::{ContractAddress, ClassHash, get_caller_address};

    #[storage]
    struct Storage {
        balance: LegacyMap<ContractAddress, u128>,
        allowance: LegacyMap<(ContractAddress, ContractAddress), u128>,
        admin: ContractAddress,
        name : felt252,
        symbol : felt252,
        totalSupply : u128
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Transfer: Transfer,
        Mint: Mint,
        Burn: Burn,
        Approval: Approval
    }

    #[derive(Drop, starknet::Event)]
    struct Transfer {
        #[key]
        sender: ContractAddress,
        to: ContractAddress,
        amount: u128
    }

    #[derive(Drop, starknet::Event)]
    struct Mint {
        #[key]
        caller: ContractAddress,
        amount: u128
    }

    #[derive(Drop, starknet::Event)]
    struct Burn {
        #[key]
        caller: ContractAddress,
        amount: u128
    }

    #[derive(Drop, PartialEq, starknet::Event)]
    struct Approval {
        #[key]
        owner: ContractAddress,
        #[key]
        spender: ContractAddress,
        value: u128
    }

    mod Errors {
        const INSUFFICIENT_BALANCE: felt252 = 'insufficient balance !';
        const INSUFFICIENT_ALLOWANCE: felt252 = 'insufficient allowance !';
        const ONLY_ADMIN: felt252 = 'Only admin !';
        const APPROVE_TO_ZERO: felt252 = 'ERC20: approve to 0';
        const CANNOT_APPROVE: felt252 = 'Cannot approve for someone else';
    }

   #[embeddable_as(Erc20CompImpl)]
    impl Counter<
        TContractState, +HasComponent<TContractState>,
    > of dao::interfaces::erc20::IErc20Comp<
        ComponentState<TContractState>
    > {

        fn get_balance(ref self: ComponentState<TContractState>, address: ContractAddress) -> u128 {
            self.balance.read(address)
        }

        fn get_symbol(ref self: ComponentState<TContractState>) -> felt252 {
            self.symbol.read()
        }

        fn get_name(ref self: ComponentState<TContractState>) -> felt252 {
            self.name.read()
        }

        fn get_allowance(ref self: ComponentState<TContractState>, owner: ContractAddress, spender: ContractAddress) -> u128 {
            self.allowance.read((owner, spender))
        }

        fn mint(ref self: ComponentState<TContractState>, address: ContractAddress, amount: u128) {
            let balance = self.balance.read(address);
            self.balance.write(address, balance - amount);
            self.emit(Mint { caller: address, amount });
        }

        fn burn(ref self: ComponentState<TContractState>, amount: u128) {
            let caller = get_caller_address();
            assert( caller == self.admin.read(), Errors::ONLY_ADMIN);
            let balance_caller = self.balance.read(caller);
            self.balance.write(caller, balance_caller - amount);
            self.emit(Burn { caller, amount });
        }

        fn transfer(ref self: ComponentState<TContractState>, to: ContractAddress, amount: u128) {
            let caller = get_caller_address();
            let balance_caller = self.balance.read(caller);
            assert(balance_caller >= amount, Errors::INSUFFICIENT_BALANCE);
            let balance_to = self.balance.read(to);
            self.balance.write(caller, balance_caller - amount);
            self.balance.write(to, balance_to + amount);
            self.emit(Transfer { sender: caller, to, amount });
        }

        fn _spend_allowance(
            ref self: ComponentState<TContractState>,
            owner: ContractAddress,
            spender: ContractAddress,
            amount: u128
        ) {
            let current_allowance = self.allowance.read((owner, spender));
            self.approve(owner, spender, current_allowance - amount);
        }

        fn transfer_from(ref self: ComponentState<TContractState>, sender: ContractAddress, recipient: ContractAddress, amount: u128 ) {
            let caller = get_caller_address();
            let balance_sender = self.balance.read(sender);
            assert(self.allowance.read((sender, caller)) >= amount, Errors::INSUFFICIENT_ALLOWANCE);
            assert(balance_sender >= amount, Errors::INSUFFICIENT_BALANCE);
            self._spend_allowance(sender, caller, amount);
            self.balance.write(sender, balance_sender - amount);
            self.balance.write(recipient, self.balance.read(recipient) + amount);
            self.emit(Transfer { sender, to : recipient, amount });
        }

        fn approve(
            ref self: ComponentState<TContractState>,
            owner: ContractAddress,
            spender: ContractAddress,
            amount: u128
        ) {
           let caller = get_caller_address();
            assert( caller == owner, Errors::CANNOT_APPROVE);
            assert(!spender.is_zero(), Errors::APPROVE_TO_ZERO);
            self.allowance.write((caller, spender), amount);
            self.emit(Approval { owner : caller, spender, value: amount });
        }


    }

    #[generate_trait]
    impl Erc20InternalImpl<
        TContractState, +HasComponent<TContractState>,
    > of Erc20InternalTrait<TContractState> {

        fn initializer(ref self: ComponentState<TContractState>, symbol : felt252, name : felt252, total_supply : u128) {
            self.symbol.write(symbol);
            self.name.write(name);
            self.totalSupply.write(total_supply);
        }
    }
}