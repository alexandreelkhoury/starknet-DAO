use serde::Serde;
use array::ArrayTrait;
use traits::TryInto;
use option::OptionTrait;
use result::ResultTrait;
use core::traits::Into;

use snforge_std::{declare, ContractClassTrait, PrintTrait, start_prank, stop_prank, CheatTarget};
use starknet::{ContractAddress, contract_address_const};

use dao::interfaces::erc20dao::{Ierc20daoDispatcher, Ierc20daoDispatcherTrait};
use dao::interfaces::erc20dao::{Ierc20daoCompDispatcher, Ierc20daoCompDispatcherTrait};

fn deploy_dao_erc20_exemple() -> ContractAddress {
    let dao_erc20_contract = declare('dao_erc20');

    let proposal = 'Sample Proposal';
    let name = 'Arbitrum';
    let symbol = 'ARB';
    let total_supply = 10000000;
    let calldata = array![proposal, name, symbol, total_supply];
    let contract_address = dao_erc20_contract.deploy(@calldata).unwrap();

    'Print the contract address'.print();
    contract_address.print();
    'Printed the contract address'.print();

    contract_address
}

#[test]
fn whitelist() {
    let contract_address = deploy_dao_erc20_exemple();
    let Component_Dispatcher = Ierc20daoCompDispatcher { contract_address };
    let alice = contract_address_const::<0x99>();

    Component_Dispatcher.whitelist(alice);
    assert(Component_Dispatcher.is_whitelisted(alice) == true,  'Incorrect result');
}

#[test]
fn unwhitelist() {
    let contract_address = deploy_dao_erc20_exemple();
    let Component_Dispatcher = Ierc20daoCompDispatcher { contract_address };
    let alice = contract_address_const::<0x99>();

    Component_Dispatcher.whitelist(alice);
    Component_Dispatcher.unwhitelist(alice);
    assert(Component_Dispatcher.is_whitelisted(alice) == false,  'Incorrect result');
}

#[test]
fn mint() {
    let contract_address = deploy_dao_erc20_exemple();
    let Component_Dispatcher = Ierc20daoCompDispatcher { contract_address };
    let alice = contract_address_const::<0x99>();

    Component_Dispatcher.whitelist(alice);
    assert(Component_Dispatcher.getResults()== 'Proposal got accepted', 'Incorrect result');
}

#[test]
fn stake() {
    let contract_address = deploy_dao_erc20_exemple();
    let Component_Dispatcher = Ierc20daoCompDispatcher { contract_address };
    let alice = contract_address_const::<0x99>();

    Component_Dispatcher.whitelist(alice);
}

#[test]
fn unstake() {
    let contract_address = deploy_dao_erc20_exemple();
    let Component_Dispatcher = Ierc20daoCompDispatcher { contract_address };
    let alice = contract_address_const::<0x99>();

    Component_Dispatcher.whitelist(alice);
}

#[test]
fn vote() {
    let contract_address = deploy_dao_erc20_exemple();
    let Component_Dispatcher = Ierc20daoCompDispatcher { contract_address };
    let alice = contract_address_const::<0x99>();
    let bob = contract_address_const::<0x98>();

    Component_Dispatcher.whitelist(alice);
}