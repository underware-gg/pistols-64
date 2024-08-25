use core::debug::PrintTrait;
use starknet::{ContractAddress, get_caller_address};
use starknet::testing::{set_contract_address, set_transaction_hash};

use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
// use planetary::systems::actions::{
//     IPlanetaryActionsDispatcher, IPlanetaryActionsDispatcherTrait,
// };

use planetary_interface::interfaces::planetary::{
    PlanetaryInterface, PlanetaryInterfaceTrait,
    IPlanetaryActionsDispatcher, IPlanetaryActionsDispatcherTrait,
};
use planetary_interface::interfaces::vulcan::{
    VulcanInterface, VulcanInterfaceTrait,
    IVulcanSaluteDispatcher, IVulcanSaluteDispatcherTrait,
};
use planetary::models::planet::{
    Planet, PlanetStore,
};

use planetary::tests::tester::{
    tester,
    tester::{flags, OWNER, PISTOLS_WORLD},
};

const PISTOLS_NAME: felt252 = 'vulcan';

#[test]
fn test_initial_state() {
    let (_world, actions, _vulcan) = tester::setup_world(0);
    let world_address: ContractAddress = tester::execute_get_world_address(actions, OWNER(), 'vulcan');
    assert(world_address.is_zero() == true, 'planet.world_address.is_zero()');
}

#[test]
fn test_register_unregister() {
    let (world, actions, _vulcan) = tester::setup_world(0);
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

#[test]
#[should_panic(expected:('PLANETARY: Unavailable', 'ENTRYPOINT_FAILED'))]
fn test_unregister_not_available() {
    let (_world, actions, _vulcan) = tester::setup_world(0);
    tester::execute_unregister(actions, tester::OWNER(), PISTOLS_NAME);
}

#[test]
fn test_get_planet() {
    let (world, _actions, vulcan) = tester::setup_world(flags::MOCK_PISTOLS64);
    // get deployed mock
    let vulcan_interface: VulcanInterface = VulcanInterfaceTrait::new_custom(world.contract_address);
    let vulcan_dispatcher: IVulcanSaluteDispatcher = vulcan_interface.dispatcher();
    assert(vulcan_dispatcher.contract_address == vulcan.contract_address, 'contract_address');
    assert(vulcan_dispatcher.live_long() == 'and_prosper', 'live_long');
}

