use core::debug::PrintTrait;
use starknet::testing::{set_contract_address, set_transaction_hash};
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

use pistols64::utils::store::{Store, StoreTrait};
use pistols64::models::{
    challenge::{Challenge},
    round::{Round},
};
use pistols64::types::{
    state::{ChallengeState},
};
use pistols64::tests::tester::{
    tester,
    tester::{Systems, ZERO, OWNER, OTHER}
};

const NAME_A: felt252 = '0000';
const NAME_B: felt252 = '9999';
const MESSAGE: felt252 = 'Fork you!';



#[test]
fn test_duel_draw() {
    let sys: Systems = tester::setup_world(0);
    let duel_id: u128 = tester::execute_create_challenge(sys.actions, OWNER(), NAME_A, NAME_B, MESSAGE);
    tester::execute_move(sys.actions, OWNER(), duel_id, 1, NAME_A, [1,1].span());
    let challenge: Challenge = sys.store.get_challenge(duel_id);
    assert(challenge.state == ChallengeState::InProgress, 'state_move_a');
    tester::execute_move(sys.actions, OWNER(), duel_id, 1, NAME_B, [1,1].span());
    let challenge: Challenge = sys.store.get_challenge(duel_id);
    assert(challenge.state == ChallengeState::Draw, 'state_move_b');
}

#[test]
fn test_duel_resolved() {
    let sys: Systems = tester::setup_world(0);
    let duel_id: u128 = tester::execute_create_challenge(sys.actions, OWNER(), NAME_A, NAME_B, MESSAGE);
    tester::execute_move(sys.actions, OWNER(), duel_id, 1, NAME_A, [1,1].span());
    let challenge: Challenge = sys.store.get_challenge(duel_id);
    assert(challenge.state == ChallengeState::InProgress, 'state_move_a');
    tester::execute_move(sys.actions, OWNER(), duel_id, 1, NAME_B, [10,1].span());
    let challenge: Challenge = sys.store.get_challenge(duel_id);
    assert(challenge.state != ChallengeState::InProgress, 'state_move_b');
}



//
// Duel fails
//

#[test]
#[should_panic(expected:('PISTOLS64: Invalid state', 'ENTRYPOINT_FAILED'))]
fn test_move_invalid_duel_id() {
    let sys: Systems = tester::setup_world(0);
    let duel_id: u128 = tester::execute_create_challenge(sys.actions, OWNER(), NAME_A, NAME_B, MESSAGE);
    tester::execute_move(sys.actions, OWNER(), duel_id, 1, NAME_A, [1,1].span());
    tester::execute_move(sys.actions, OWNER(), duel_id, 1, NAME_B, [1,1].span());
    tester::execute_move(sys.actions, OWNER(), duel_id, 1, NAME_B, [1,1].span());
}

#[test]
#[should_panic(expected:('ROUND: Invalid moves length', 'ENTRYPOINT_FAILED'))]
fn test_move_invalid_moves_length() {
    let sys: Systems = tester::setup_world(0);
    let duel_id: u128 = tester::execute_create_challenge(sys.actions, OWNER(), NAME_A, NAME_B, MESSAGE);
    tester::execute_move(sys.actions, OWNER(), duel_id, 1, NAME_A, [0].span());
}

#[test]
#[should_panic(expected:('ROUND: Invalid paces', 'ENTRYPOINT_FAILED'))]
fn test_move_invalid_paces() {
    let sys: Systems = tester::setup_world(0);
    let duel_id: u128 = tester::execute_create_challenge(sys.actions, OWNER(), NAME_A, NAME_B, MESSAGE);
    tester::execute_move(sys.actions, OWNER(), duel_id, 1, NAME_A, [0, 0].span());
}

#[test]
#[should_panic(expected:('ROUND: Invalid dodge', 'ENTRYPOINT_FAILED'))]
fn test_move_invalid_dodge() {
    let sys: Systems = tester::setup_world(0);
    let duel_id: u128 = tester::execute_create_challenge(sys.actions, OWNER(), NAME_A, NAME_B, MESSAGE);
    tester::execute_move(sys.actions, OWNER(), duel_id, 1, NAME_A, [1, 0].span());
}
