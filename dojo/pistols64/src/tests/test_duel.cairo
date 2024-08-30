use core::debug::PrintTrait;
use starknet::testing::{set_contract_address, set_transaction_hash};
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

use pistols64::utils::store::{Store, StoreTrait};
use pistols64::systems::{
    actions::{IActionsDispatcher, IActionsDispatcherTrait},
};
use pistols64::models::{
    challenge::{Challenge, ChallengeTrait, ChallengeResults},
    round::{Round, RoundTrait},
};
use pistols64::types::{
    state::{ChallengeState, ChallengeStateTrait},
};
use pistols64::types::cards::{
    paces::{PacesCard, PacesCardTrait},
    tactics::{TacticsCard, TacticsCardTrait},
    blades::{BladesCard, BladesCardTrait},
};

use pistols64::tests::tester::{
    tester,
    tester::{
        Systems, IRngDispatcher, IRngDispatcherTrait,
        FLAGS, ZERO, OWNER, OTHER,
    }
};

const NAME_A: felt252 = '0000';
const NAME_B: felt252 = '9999';
const MESSAGE: felt252 = 'Fork you!';



#[test]
fn test_seeds() {
    let sys: Systems = tester::setup_world(0);
    let duel_id_1: u128 = tester::execute_create_challenge(sys.actions, OWNER(), NAME_A, NAME_B, MESSAGE);
    let duel_id_2: u128 = tester::execute_create_challenge(sys.actions, OWNER(), NAME_A, NAME_B, MESSAGE);
    assert(duel_id_1 != duel_id_2, 'same id');
    tester::execute_move(sys.actions, OWNER(), duel_id_1, 1, NAME_A, [1,10].span());
    tester::execute_move(sys.actions, OWNER(), duel_id_1, 1, NAME_B, [1,10].span());
    tester::execute_move(sys.actions, OWNER(), duel_id_2, 1, NAME_A, [1,10].span());
    tester::execute_move(sys.actions, OWNER(), duel_id_2, 1, NAME_B, [1,10].span());
    let round_1: Round = sys.store.get_round(duel_id_1, 1);
    let round_2: Round = sys.store.get_round(duel_id_2, 1);
// duel_id_1.print();
// duel_id_2.print();
// round_1.shot_a.dice_crit.print();
// round_2.shot_a.dice_crit.print();
// round_1.shot_b.dice_crit.print();
// round_2.shot_b.dice_crit.print();
    assert(round_1.shot_a.dice_crit != round_1.shot_b.dice_crit, 'round 1_a != 1_b');
    assert(round_2.shot_a.dice_crit != round_2.shot_b.dice_crit, 'round 2_a != 2_b');
    assert(round_1.shot_a.dice_crit != round_2.shot_a.dice_crit, 'round 1_a != 2_a');
}


#[test]
fn test_duel_draw() {
    let sys: Systems = tester::setup_world(0);
    let duel_id: u128 = tester::execute_create_challenge(sys.actions, OWNER(), NAME_A, NAME_B, MESSAGE);
    tester::execute_move(sys.actions, OWNER(), duel_id, 1, NAME_A, [1,1].span());
    let challenge: Challenge = sys.store.get_challenge(duel_id);
    assert(challenge.state == ChallengeState::InProgress, 'state_move_a');
    tester::execute_move(sys.actions, OWNER(), duel_id, 1, NAME_B, [1,1].span());
    let challenge: Challenge = sys.store.get_challenge(duel_id);
    assert(challenge.state == ChallengeState::Draw, 'state_final');
}

#[test]
fn test_duel_resolved_a() {
    let sys: Systems = tester::setup_world(FLAGS::MOCK_RNG);
    sys.rng.set_salts(['shoot_a', 'shoot_b'].span(), [1, 100].span());
    let duel_id: u128 = tester::execute_create_challenge(sys.actions, OWNER(), NAME_A, NAME_B, MESSAGE);
    tester::execute_move(sys.actions, OWNER(), duel_id, 1, NAME_A, [6, 1].span());
    let challenge: Challenge = sys.store.get_challenge(duel_id);
    assert(challenge.state == ChallengeState::InProgress, 'state_move_a');
    tester::execute_move(sys.actions, OWNER(), duel_id, 1, NAME_B, [5, 1].span());
    let challenge: Challenge = sys.store.get_challenge(duel_id);
    assert(challenge.state == ChallengeState::Resolved, 'state_final');
    assert(challenge.winner == 1, 'winner');
    // validate MOCK_RNG
    let round: Round = sys.store.get_round(duel_id, 1);
    assert(round.shot_a.dice_crit == 1, 'dice_a');
    assert(round.shot_b.dice_crit == 100, 'dice_b');
    // check results
    let results: ChallengeResults = sys.actions.get_challenge_results(duel_id);
    assert(results.is_finished == true, 'results_is_finished');
    assert(results.winner == challenge.winner, 'results_winner');
    assert(results.duelist_name_a == NAME_A, 'results_NAME_A');
    assert(results.duelist_name_b == NAME_B, 'results_NAME_B');
    assert(results.message == MESSAGE, 'results_message');
}

#[test]
fn test_duel_resolved_b() {
    let sys: Systems = tester::setup_world(FLAGS::MOCK_RNG);
    sys.rng.set_salts(['shoot_a', 'shoot_b'].span(), [100, 1].span());
    let duel_id: u128 = tester::execute_create_challenge(sys.actions, OWNER(), NAME_A, NAME_B, MESSAGE);
    tester::execute_move(sys.actions, OWNER(), duel_id, 1, NAME_A, [5, 1].span());
    let challenge: Challenge = sys.store.get_challenge(duel_id);
    assert(challenge.state == ChallengeState::InProgress, 'state_move_a');
    tester::execute_move(sys.actions, OWNER(), duel_id, 1, NAME_B, [6, 1].span());
    let challenge: Challenge = sys.store.get_challenge(duel_id);
    assert(challenge.state == ChallengeState::Resolved, 'state_final');
    assert(challenge.winner == 2, 'winner');
    // validate MOCK_RNG
    let round: Round = sys.store.get_round(duel_id, 1);
    assert(round.shot_a.dice_crit == 100, 'dice_a');
    assert(round.shot_b.dice_crit == 1, 'dice_b');
    // check results
    let results: ChallengeResults = sys.actions.get_challenge_results(duel_id);
    assert(results.is_finished == true, 'results_is_finished');
    assert(results.winner == challenge.winner, 'results_winner');
    assert(results.duelist_name_a == NAME_A, 'results_NAME_A');
    assert(results.duelist_name_b == NAME_B, 'results_NAME_B');
    assert(results.message == MESSAGE, 'results_message');
}

// TODO: dodge + get shot




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
