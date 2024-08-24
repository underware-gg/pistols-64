use core::debug::PrintTrait;
use starknet::{ContractAddress, get_caller_address};
use starknet::testing::{set_contract_address, set_transaction_hash};

use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use planetary::systems::actions::{
    IPlanetaryActionsDispatcher, IPlanetaryActionsDispatcherTrait,
};

use planetary::models::planet::{
    planet, Planet, PlanetStore,
};
use planetary::interfaces::pistols64::{
    IPistols64ActionsDispatcher,
    Pistols64Interface, Pistols64InterfaceTrait,
};

use planetary::tests::tester::{
    tester,
    tester::{flags, OWNER, PISTOLS_WORLD},
};

const PISTOLS_NAME: felt252 = 'pistols64';

#[test]
fn test_initial_state() {
    let (_world, actions, _pistols64) = tester::setup_world(0);
    let world_address: ContractAddress = tester::execute_get_world_address(actions, OWNER(), 'pistols64');
    assert(world_address.is_zero() == true, 'planet.world_address.is_zero()');
}

#[test]
fn test_register_unregister() {
    let (world, actions, _pistols64) = tester::setup_world(0);
    tester::execute_register(actions, tester::OWNER(), PISTOLS_NAME, PISTOLS_WORLD());
    let world_address: ContractAddress = tester::execute_get_world_address(actions, OWNER(), PISTOLS_NAME);
    assert(world_address == PISTOLS_WORLD(), 'planet.world_address.is_zero()');
    // check planet
    let planet: Planet = PlanetStore::get(world, PISTOLS_NAME);
    assert(planet.world_address == world_address, 'planet.world_address');
    assert(planet.is_available == true, 'planet.is_available');
    // unregister
    tester::execute_unregister(actions, tester::OWNER(), PISTOLS_NAME);
    let planet: Planet = PlanetStore::get(world, PISTOLS_NAME);
    assert(planet.is_available == false, 'planet.is_available');
}

// need to use test world address from planetary interface!
#[test]
#[ignore]
#[should_panic(expected:('CONTRACT_NOT_DEPLOYED',))]
fn test_get_planet() {
    let (_world, actions, _pistols64) = tester::setup_world(flags::MOCK_PISTOLS64);
    tester::execute_register(actions, tester::OWNER(), PISTOLS_NAME, PISTOLS_WORLD());
    let world_address: ContractAddress = tester::execute_get_world_address(actions, OWNER(), PISTOLS_NAME);
    assert(world_address == PISTOLS_WORLD(), 'planet.world_address.is_zero()');
    // pistos is not deployed!
    let _interface: IPistols64ActionsDispatcher = Pistols64InterfaceTrait::new(world_address).actions_dispatcher();
}

#[test]
#[should_panic(expected:('PLANETARY: Unavailable', 'ENTRYPOINT_FAILED'))]
fn test_unregister_not_available() {
    let (_world, actions, _pistols64) = tester::setup_world(0);
    tester::execute_unregister(actions, tester::OWNER(), PISTOLS_NAME);
}
