use core::debug::PrintTrait;
use starknet::testing::{set_contract_address, set_transaction_hash};

use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use dojo::utils::test::{spawn_test_world, deploy_contract};

use planetary::models::planet::{
    planet, Planet,
};
use planetary::components::planetary::planetary_component::{
    PlanetaryImpl,
};

use planetary::tests::mock_component::mock_component;

fn STATE() -> (IWorldDispatcher, mock_component::ContractState) {
    let world = spawn_test_world(
        ["planetary"].span(),
        [planet::TEST_CLASS_HASH].span()
    );

    let mut state = mock_component::contract_state_for_testing();
    state.world_dispatcher.write(world);

    (world, state)
}

#[test]
fn test_ping_pong() {
    let (_world, mut state) = STATE();
    let pong = state.ping();
    assert(pong == 'pong', 'pong');
}
