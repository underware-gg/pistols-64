use starknet::ContractAddress;
use pistols64::types::state::ChallengeState;

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Round {
    #[key]
    duel_id: u128,
    #[key]
    round_number: u8,
    //---------------
    shot_a: Shot,   // duelist_a shot
    shot_b: Shot,   // duelist_b shot
}

//
// The shot of each player on a Round
#[derive(Copy, Drop, Serde, IntrospectPacked)]
struct Shot {
    // player input
    hash: u64,          // hashed action (salt + action)
    salt: u64,          // the player's secret salt
    action: u16,        // the player's chosen action(s) (paces, weapon, ...)
    // shot results
    chance_crit: u8,    // computed chances (1..100) - execution
    chance_hit: u8,     // computed chances (1..100) - hit / normal damage
    chance_lethal: u8,  // computed chances (1..100) - hit / double damage
    dice_crit: u8,      // dice roll result (1..100) - execution
    dice_hit: u8,       // dice roll result (1..100) - hit / normal damage
    damage: u8,         // amount of health taken
    block: u8,          // amount of damage blocked
    win: u8,            // wins the round
    wager: u8,          // wins the wager
    // player state
    health: u8,         // final health
    honour: u8,         // honour granted
}



//--------------------------
// Traits
//

trait RoundTrait {
    fn duelist_number(self: Round, duelist_name: felt252) -> u8;
}

impl RoundTraitImpl of RoundTrait {
    fn duelist_number(self: Round, duelist_name: felt252) -> u8 {
        0
    }
}