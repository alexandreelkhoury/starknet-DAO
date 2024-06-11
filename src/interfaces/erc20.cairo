use starknet::{ContractAddress, ClassHash};

#[starknet::interface]
trait IErc20<TContractState> {
    fn transfer(ref self: TContractState, to: ContractAddress, amount: u128);
    fn mint(ref self: TContractState, address: ContractAddress, amount: u128);
    fn burn(ref self: TContractState, amount: u128);
    fn get_balance(ref self: TContractState, address: ContractAddress) -> u128 ;
    fn get_symbol(ref self: TContractState) -> felt252 ;
    fn get_name(ref self: TContractState) -> felt252 ;
    fn get_allowance(ref self: TContractState, owner: ContractAddress, spender: ContractAddress) -> u128;
    fn transfer_from(ref self: TContractState, sender: ContractAddress, recipient: ContractAddress, amount: u128);
    fn _spend_allowance(ref self: TContractState, owner : ContractAddress, spender: ContractAddress, amount: u128);
    fn approve(ref self: TContractState, owner: ContractAddress, spender: ContractAddress, amount: u128);
}

#[starknet::interface]
trait IErc20Comp<TComponentState> {
    fn transfer(ref self: TComponentState, to: ContractAddress, amount: u128);
    fn mint(ref self: TComponentState, address: ContractAddress, amount: u128);
    fn burn(ref self: TComponentState, amount: u128);
    fn get_balance(ref self: TComponentState, address: ContractAddress) -> u128 ;
    fn get_symbol(ref self: TComponentState) -> felt252 ;
    fn get_name(ref self: TComponentState) -> felt252 ;
    fn get_allowance(ref self: TComponentState, owner: ContractAddress, spender: ContractAddress) -> u128;
    fn transfer_from(ref self: TComponentState, sender: ContractAddress, recipient: ContractAddress, amount: u128);
    fn _spend_allowance(ref self: TComponentState, owner : ContractAddress, spender: ContractAddress, amount: u128);
    fn approve(ref self: TComponentState, owner: ContractAddress, spender: ContractAddress, amount: u128);
}