use core::debug::PrintTrait;
use starknet::testing::{set_contract_address, set_transaction_hash};
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

use pistols64::utils::store::{Store, StoreTrait};
use pistols64::models::{
    challenge::{Challenge},
};
use pistols64::tests::tester::{
    tester,
    tester::{Systems, ZERO, OWNER, OTHER}
};

const NAME_A: felt252 = 'Duke';
const NAME_B: felt252 = 'Duchess';
const MESSAGE: felt252 = 'Fork you!';



#[test]
fn test_create_challenge() {
    // [Setup]
    let sys: Systems = tester::setup_world(0);
    let duel_id: u128 = tester::execute_create_challenge(sys.actions, OWNER(), NAME_A, NAME_B, MESSAGE);
    let challenge: Challenge = sys.store.get_challenge(duel_id);
    assert(challenge.duel_id == duel_id, 'duel_id');
    assert(challenge.name_a == NAME_A, 'name_a');
    assert(challenge.name_b == NAME_B, 'name_b');
    assert(challenge.message == MESSAGE, 'message');
}


