use starknet::ContractAddress;
use pistols64::types::state::ChallengeState;
use pistols64::models::round::{Round, RoundTrait};
use pistols64::systems::rng::{Rng, RngTrait};

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Challenge {
    #[key]
    pub duel_id: u128,
    //-------------------------
    pub address_a: ContractAddress,     // Challenger wallet
    pub address_b: ContractAddress,     // Challenged wallet
    pub duelist_name_a: felt252,        // Challenger name
    pub duelist_name_b: felt252,        // Challenged name 
    pub message: felt252,               // message to challenged
    // progress and results
    pub state: ChallengeState,
    pub winner: u8,                     // 0:draw, 1:duelist_a, 2:duelist_b
}

// for planetary interface
#[derive(Copy, Drop, Serde)]
struct ChallengeResults {
    duel_id: u128,
    duelist_name_a: felt252,
    duelist_name_b: felt252,
    message: felt252,
    moves_a: Span<u8>,
    moves_b: Span<u8>,
    is_finished: bool,
    winner: u8,     // 0 (draw), 1 (A wins), 2 (B wins)
}



//--------------------------
// Traits
//

trait ChallengeTrait {
    fn duelist_number(self: Challenge, duelist_name: felt252) -> u8;
    fn finalize(ref self: Challenge, ref rng: Rng, ref round: Round);
}

impl ChallengeImpl of ChallengeTrait {
    fn duelist_number(self: Challenge, duelist_name: felt252) -> u8 {
        (
            if (self.duelist_name_a == duelist_name) { 1 }
            else if (self.duelist_name_b == duelist_name) { 2 }
            else { 0 }
        )
    }
    fn finalize(ref self: Challenge, ref rng: Rng, ref round: Round) {
        self.winner = round.duel(ref rng);
        self.state = if(self.winner > 0) {ChallengeState::Resolved} else {ChallengeState::Draw};
    }
}
