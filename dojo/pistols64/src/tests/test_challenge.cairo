use core::debug::PrintTrait;
use starknet::testing::{set_contract_address, set_transaction_hash};
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use pistols64::tests::tester::{tester};

#[test]
fn test_actions_attack() {
    // [Setup]
    let (_world, _actions) = tester::setup_world(0);
    assert(true, 'very true');
}
