use starknet::{ContractAddress, ClassHash};

#[starknet::interface]
trait Ierc20dao<TContractState> {
    fn whitelist(ref self: TContractState, address: ContractAddress);
    fn unwhitelist(ref self: TContractState, address: ContractAddress);
    fn is_whitelisted(ref self: TContractState, address: ContractAddress) -> bool;
    fn vote(ref self: TContractState, vote: bool);
    fn getResults(ref self: TContractState) -> felt252 ;
    fn transfer(ref self: TContractState, to: ContractAddress, amount: u128);
    fn mint(ref self: TContractState,  address: ContractAddress, amount: u128);
    fn burn(ref self: TContractState, amount: u128);
    fn stake(ref self: TContractState, amount: u128);
    fn unstake(ref self: TContractState, amount: u128);
    fn get_balance(ref self: TContractState, address: ContractAddress) -> u128 ;
    fn get_symbol(ref self: TContractState) -> felt252 ;
    fn get_name(ref self: TContractState) -> felt252 ;
    fn get_allowance(ref self: TContractState, owner: ContractAddress, spender: ContractAddress) -> u128;
    fn transfer_from(ref self: TContractState, sender: ContractAddress, recipient: ContractAddress, amount: u128);
    fn _spend_allowance(ref self: TContractState, owner : ContractAddress, spender: ContractAddress, amount: u128);
    fn approve(ref self: TContractState, owner: ContractAddress, spender: ContractAddress, amount: u128);
}

#[starknet::interface]
trait Ierc20daoComp<TComponentState> {
    fn whitelist(ref self: TComponentState, address: ContractAddress);
    fn unwhitelist(ref self: TComponentState, address: ContractAddress);
    fn is_whitelisted(ref self: TComponentState, address: ContractAddress) -> bool;
    fn vote(ref self: TComponentState, vote: bool);
    fn getResults(ref self: TComponentState) -> felt252 ;
    fn transfer(ref self: TComponentState, to: ContractAddress, amount: u128);
    fn mint(ref self: TComponentState,  address: ContractAddress, amount: u128);
    fn burn(ref self: TComponentState, amount: u128);
    fn stake(ref self: TComponentState, amount: u128);
    fn unstake(ref self: TComponentState, amount: u128);
    fn get_balance(ref self: TComponentState, address: ContractAddress) -> u128 ;
    fn get_symbol(ref self: TComponentState) -> felt252 ;
    fn get_name(ref self: TComponentState) -> felt252 ;
    fn get_allowance(ref self: TComponentState, owner: ContractAddress, spender: ContractAddress) -> u128;
    fn transfer_from(ref self: TComponentState, sender: ContractAddress, recipient: ContractAddress, amount: u128);
    fn _spend_allowance(ref self: TComponentState, owner : ContractAddress, spender: ContractAddress, amount: u128);
    fn approve(ref self: TComponentState, owner: ContractAddress, spender: ContractAddress, amount: u128);
}