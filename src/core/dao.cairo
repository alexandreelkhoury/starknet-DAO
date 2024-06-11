#[starknet::contract]
mod Dao {
    use dao::components::dao_component::DaoComponent;
    use dao::components::dao_component::DaoComponent::DaoInternalTrait;

    component!(path: DaoComponent, storage: dao, event: DaoEvents);

    #[abi(embed_v0)]
    impl DaoCompImpl = DaoComponent::DaoCompImpl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        dao: DaoComponent::Storage,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        DaoEvents: DaoComponent::Event,
    }

    #[constructor]
    fn constructor(ref self: ContractState, value: felt252) {
        self.dao.initializer(value);
    }
}
