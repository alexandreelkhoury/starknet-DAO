use starknet::{ContractAddress, ClassHash};

#[starknet::contract]
mod DaoErc20 {
    use starknet::{ContractAddress, ClassHash, get_caller_address};

    use dao::components::erc20_component::Erc20Component;
    use dao::components::erc20_component::Erc20Component::Erc20InternalTrait;
    use dao::components::dao_component::DaoComponent;
    use dao::components::dao_component::DaoComponent::DaoInternalTrait;

    component!(path: Erc20Component, storage: erc20, event: Erc20Events);
    component!(path: DaoComponent, storage: dao, event: DaoEvents);

    #[abi(embed_v0)]
    impl Erc20CompImpl = Erc20Component::Erc20CompImpl<ContractState>;
    #[abi(embed_v0)]
    impl DaoCompImpl = DaoComponent::DaoCompImpl<ContractState>;

    #[storage]
    struct Storage {
        whitelist: LegacyMap<ContractAddress, bool>,
        staking: LegacyMap<ContractAddress, u128>,
        admin: ContractAddress,
        #[substorage(v0)]
        erc20: Erc20Component::Storage,
        #[substorage(v0)]
        dao: DaoComponent::Storage,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        Erc20Events: Erc20Component::Event,
        #[flat]
        DaoEvents: DaoComponent::Event,
    }

     mod Errors {
        const INSUFFICIENT_BALANCE: felt252 = 'insufficient balance !';
        const ONLY_ADMIN: felt252 = 'Only admin !';
    }

    #[constructor]
    fn constructor(ref self: ContractState, symbol : felt252, name : felt252, total_supply : u128, value: felt252) {
        self.admin.write(get_caller_address());
        self.erc20.initializer(symbol, name, total_supply);
        self.dao.initializer(value);
    }

    impl Erc20DaoImpl of dao::interfaces::erc20dao::Ierc20dao<ContractState> {
        fn whitelist(ref self: ContractState, address: ContractAddress) {
            assert(get_caller_address() == self.admin.read(), Errors::ONLY_ADMIN);
            self.whitelist.write(address, true);
        }

        fn unwhitelist(ref self: ContractState, address: ContractAddress) {
            assert(get_caller_address() == self.admin.read(), Errors::ONLY_ADMIN);
            self.whitelist.write(address, false);
        }

        fn is_whitelisted(ref self: ContractState, address: ContractAddress) -> bool {
            self.whitelist.read(address)
        }

        fn mint(ref self: ContractState, address: ContractAddress, amount: u128) {
            let caller = get_caller_address();
            assert(self.whitelist.read(address), 'Address not whitelisted !');
            self.erc20.mint(address, amount);
        }

        fn stake(ref self: ContractState, amount: u128) {
            let caller = get_caller_address();
            let balance_caller = self.erc20.balance.read(caller);
            assert(balance_caller >= amount, Errors::INSUFFICIENT_BALANCE);
            self.staking.write(caller, amount);
        }

        fn vote(ref self: ContractState, vote: bool) {
            assert(self.staking.read(get_caller_address()) > 100, 'Minimum 100 to vote !');
            self.dao.vote(vote);
        }

        fn unstake(ref self: ContractState, amount: u128) {
            let caller = get_caller_address();
            let staking_balance = self.staking.read(caller);
            assert(staking_balance >= amount, Errors::INSUFFICIENT_BALANCE);
            self.staking.write(caller, staking_balance - amount);
        }

        fn getResults(ref self: ContractState) -> felt252 {
            self.dao.getResults()
        }

        fn transfer(ref self: ContractState, to: ContractAddress, amount: u128) {
            self.erc20.transfer(to, amount);
        }

        fn burn(ref self: ContractState, amount: u128) {
            self.erc20.burn(amount);
        }

        fn get_balance(ref self: ContractState, address: ContractAddress) -> u128 {
            self.erc20.get_balance(address)
        }

        fn get_symbol(ref self: ContractState) -> felt252 {
            self.erc20.get_symbol()
        }

        fn get_name(ref self: ContractState) -> felt252 {
            self.erc20.get_name()
        }

        fn get_allowance(ref self: ContractState, owner: ContractAddress, spender: ContractAddress) -> u128 {
            self.erc20.get_allowance(owner, spender)
        }

        fn transfer_from(ref self: ContractState, sender: ContractAddress, recipient: ContractAddress, amount: u128) {
            self.erc20.transfer_from(sender, recipient, amount);
        }

        fn _spend_allowance(ref self: ContractState, owner: ContractAddress, spender: ContractAddress, amount: u128) {
            self.erc20._spend_allowance(owner, spender, amount);
        }

        fn approve(ref self: ContractState, owner: ContractAddress, spender: ContractAddress, amount: u128) {
            self.erc20.approve(owner, spender, amount);
        }
    }
}
