use starknet::{ContractAddress, ClassHash};

#[starknet::interface]
trait IDao<TContractState> {
    fn vote(ref self: TContractState, vote: bool);
    fn getResults(ref self: TContractState) -> felt252 ;
}

#[starknet::interface]
trait IDaoComp<TComponentState> {
    fn vote(ref self: TComponentState, vote: bool);
    fn getResults(ref self: TComponentState) -> felt252 ;
}
