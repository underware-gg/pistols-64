use core::debug::PrintTrait;
use starknet::testing::{set_contract_address, set_transaction_hash};
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

use pistols64::utils::store::{Store, StoreTrait};
use pistols64::models::{
    challenge::{Challenge},
    round::{Round, RoundTrait, Shot, ShotTrait},
};
use pistols64::types::{
    state::{ChallengeState},
};
use pistols64::tests::tester::{
    tester,
    tester::{Systems, ZERO, OWNER, OTHER}
};

const NAME_A: felt252 = '000';
const NAME_B: felt252 = 'ZZZ';
const MESSAGE: felt252 = 'Fork you!';



#[test]
fn test_create_challenge() {
    let sys: Systems = tester::setup_world(0);
    let duel_id: u128 = tester::execute_create_challenge(sys.actions, OWNER(), NAME_A, NAME_B, MESSAGE);
    let challenge: Challenge = sys.store.get_challenge(duel_id);
    assert(challenge.duel_id == duel_id, 'duel_id');
    assert(challenge.duelist_name_a == NAME_A, 'name_a');
    assert(challenge.duelist_name_b == NAME_B, 'name_b');
    assert(challenge.message == MESSAGE, 'message');
    assert(challenge.state == ChallengeState::InProgress, 'message');
}

//
// Challenge fails
//

#[test]
#[should_panic(expected:('PISTOLS64: Invalid name A', 'ENTRYPOINT_FAILED'))]
fn test_create_challenge_invalid_name_a() {
    let sys: Systems = tester::setup_world(0);
    tester::execute_create_challenge(sys.actions, OWNER(), 'ZZ', NAME_B, MESSAGE);
}

#[test]
#[should_panic(expected:('PISTOLS64: Invalid name B', 'ENTRYPOINT_FAILED'))]
fn test_create_challenge_invalid_name_b() {
    let sys: Systems = tester::setup_world(0);
    tester::execute_create_challenge(sys.actions, OWNER(), NAME_A, 'ZZ', MESSAGE);
}

#[test]
#[should_panic(expected:('PISTOLS64: Names are equal', 'ENTRYPOINT_FAILED'))]
fn test_create_challenge_invalid_names() {
    let sys: Systems = tester::setup_world(0);
    tester::execute_create_challenge(sys.actions, OWNER(), NAME_A, NAME_A, MESSAGE);
}

//
// Move fails
//

#[test]
#[should_panic(expected:('PISTOLS64: Invalid challenge', 'ENTRYPOINT_FAILED'))]
fn test_move_invalid_duel_id() {
    let sys: Systems = tester::setup_world(0);
    tester::execute_move(sys.actions, OWNER(), 0x1234, 1, NAME_A, [0].span());
}

#[test]
#[should_panic(expected:('PISTOLS64: Invalid caller', 'ENTRYPOINT_FAILED'))]
fn test_move_invalid_caller() {
    let sys: Systems = tester::setup_world(0);
    let duel_id: u128 = tester::execute_create_challenge(sys.actions, OWNER(), NAME_A, NAME_B, MESSAGE);
    tester::execute_move(sys.actions, OTHER(), duel_id, 1, NAME_A, [0].span());
}

#[test]
#[should_panic(expected:('PISTOLS64: Invalid duelist', 'ENTRYPOINT_FAILED'))]
fn test_move_invalid_duelist() {
    let sys: Systems = tester::setup_world(0);
    let duel_id: u128 = tester::execute_create_challenge(sys.actions, OWNER(), NAME_A, NAME_B, MESSAGE);
    tester::execute_move(sys.actions, OWNER(), duel_id, 1, 'AASSAFSDFSD', [0].span());
}

