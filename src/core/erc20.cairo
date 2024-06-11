#[starknet::contract]
mod Erc20 {
    use dao::components::erc20_component::Erc20Component;
    use dao::components::erc20_component::Erc20Component::Erc20InternalTrait;

    component!(path: Erc20Component, storage: erc20, event: Erc20Events);

    #[abi(embed_v0)]
    impl Erc20CompImpl = Erc20Component::Erc20CompImpl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        erc20: Erc20Component::Storage,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        Erc20Events: Erc20Component::Event,
    }


    #[constructor]
    fn constructor(ref self: ContractState, symbol : felt252, name : felt252, total_supply : u128) {
        self.erc20.initializer(symbol, name, total_supply);
    }
}
