use starknet::ContractAddress;
use pistols64::types::state::ChallengeState;
use pistols64::types::cards::{
    paces::{PacesCard, PacesCardTrait},
    tactics::{TacticsCard, TacticsCardTrait},
    blades::{BladesCard, BladesCardTrait},
};
use pistols64::types::constants::{CONST};

mod Errors {
    const InvalidMovesLength: felt252 = 'ROUND: Invalid moves length';
    const InvalidPaces: felt252 = 'ROUND: Invalid paces';
    const InvalidDodge: felt252 = 'ROUND: Invalid dodge';
}


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
#[derive(Copy, Drop, Serde, Introspect)]
struct Shot {
    // player input
    card_paces: PacesCard,
    card_dodge: PacesCard,
    card_tactics: TacticsCard,
    card_blades: BladesCard,
    // initial state
    initial_chances: u8,    // 0-100
    initial_damage: u8,     // CONST::INITIAL_CHANCE
    initial_health: u8,     // CONST::FULL_HEALTH
    // final states
    final_chances: u8,      // 0-100
    final_damage: u8,
    final_health: u8,
    // results
    dice_crit: u8,          // 0-100
    win: u8,                // won the round?
}



//--------------------------
// Shot Traits
//

trait ShotTrait {
    fn initialize(ref self: Shot, moves: Span<u8>);
}

impl ShotImpl of ShotTrait {
    fn initialize(ref self: Shot, moves: Span<u8>) {
        assert(moves.len() >= 2, Errors::InvalidMovesLength);
        self.card_paces = (*moves[0]).into();
        self.card_dodge = (*moves[1]).into();
        assert(self.card_paces != PacesCard::Null, Errors::InvalidPaces);
        assert(self.card_dodge != PacesCard::Null, Errors::InvalidDodge);
        self.card_tactics = if (moves.len() >= 3) {(*moves[2]).into()} else {0_u8.into()};
        self.card_blades =  if (moves.len() >= 4) {(*moves[3]).into()} else {0_u8.into()};
        self.initial_chances = CONST::INITIAL_CHANCE;
        self.initial_health = CONST::FULL_HEALTH;
        self.final_health = CONST::FULL_HEALTH;         // unless die!
    }
}



//--------------------------
// Round Traits
//

trait RoundTrait {
    fn duel(ref self: Round) -> u8;
}

impl RoundImpl of RoundTrait {
    fn duel(ref self: Round) -> u8 {
        let mut shot_a = self.shot_a;
        let mut shot_b = self.shot_b;

        // TODO: apply tactics card
        // TODO: apply blades cards
        // card_tactics.apply(shot_a);
        // card_tactics.apply(shot_b);

        let mut seed: felt252 = self.duel_id.into();
        let mut winner: u8 = 0;

        let mut pace_number: u8 = 1;
        while (pace_number <= 10) {
            let pace = pace_number.into();
            // println!("Pace [{}] A:{} B:{}", pace_number, shot_a.card_paces.as_felt(), shot_b.card_paces.as_felt());

            // TODO: draw env cards
            // TODO: apply env card to shots
            // update shot.final_chances
            // update shot.final_damage

            //
            // Shoot!
            let mut executed_a: bool = false;
            let mut executed_b: bool = false;
            if (shot_a.card_paces == pace) {
                executed_b = shot_a.card_paces.shoot(ref shot_a, ref shot_b, ref seed);
            }
            if (shot_b.card_paces == pace) {
                executed_a = shot_b.card_paces.shoot(ref shot_b, ref shot_a, ref seed);
            }
            if (executed_a || executed_b) {
                if (!executed_a) {
                    winner = 1;
                } else if (!executed_b) {
                    winner = 2;
                }
                break;
            }

            //
            // Blades
            if (shot_a.dice_crit > 0 && shot_b.dice_crit > 0) {
                //TODO: duel blades
                break;
            }
            
            pace_number += 1;
        };
 
        (winner)
    }
}



