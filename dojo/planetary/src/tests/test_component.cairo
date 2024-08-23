use core::debug::PrintTrait;
use starknet::testing::{set_contract_address, set_transaction_hash};

use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

use planetary::models::planet::{
    Planet,
};
use planetary::components::planetary::planetary_component::{
    PlanetaryImpl,
};

use planetary::tests::tester::{tester};

#[test]
fn test_ping_pong() {
    let (_world, mut state) = tester::STATE();
    let pong = state.ping();
    assert(pong == 'pong', 'pong');
}
