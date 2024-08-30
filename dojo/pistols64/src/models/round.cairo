use starknet::ContractAddress;
use pistols64::types::state::ChallengeState;
use pistols64::types::cards::{
    paces::{PacesCard, PacesCardTrait},
    tactics::{TacticsCard, TacticsCardTrait},
    blades::{BladesCard, BladesCardTrait},
};
use pistols64::types::constants::{CONST};
use pistols64::systems::rng::{Rng, RngTrait};

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
    initial_health: u8,     // CONST::FULL_HEALTH
    initial_damage: u8,     // CONST::INITIAL_CHANCE
    initial_chances: u8,    // 0-100
    // final states
    final_health: u8,
    final_damage: u8,
    final_chances: u8,      // 0-100
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
        self.initial_health = CONST::FULL_HEALTH;
        self.initial_damage = CONST::INITIAL_DAMAGE;
        self.initial_chances = CONST::INITIAL_CHANCE;
        self.final_health = self.initial_health;
        self.final_damage = self.initial_damage;
        self.final_chances = self.initial_chances;
    }
}



//--------------------------
// Round Traits
//

trait RoundTrait {
    fn duel(ref self: Round, ref rng: Rng) -> u8;
}

impl RoundImpl of RoundTrait {
    fn duel(ref self: Round, ref rng: Rng) -> u8 {

        // TODO: apply tactics card
        // TODO: apply blades cards
        // card_tactics.apply(self.shot_a);
        // card_tactics.apply(self.shot_b);

        let mut winner: u8 = 0;

        let mut pace_number: u8 = 1;
        while (pace_number <= 10) {
            let pace = pace_number.into();
            // println!("Pace [{}] A:{} B:{}", pace_number, self.shot_a.card_paces.as_felt(), self.shot_b.card_paces.as_felt());

            // TODO: draw env cards
            // TODO: apply env card to shots
            // update shot.final_chances
            // update shot.final_damage

            //
            // Shoot!
            let mut executed_a: bool = false;
            let mut executed_b: bool = false;
            if (self.shot_a.card_paces == pace) {
                executed_b = self.shot_a.card_paces.shoot(ref rng, ref self.shot_a, ref self.shot_b, 'shoot_a');
            }
            if (self.shot_b.card_paces == pace) {
                executed_a = self.shot_b.card_paces.shoot(ref rng, ref self.shot_b, ref self.shot_a, 'shoot_b');
            }
            // break if there's a winner
            if (executed_a || executed_b) {
                if (!executed_a) {
                    winner = 1;
                } else if (!executed_b) {
                    winner = 2;
                }
                break;
            }

            //
            // both dices rolled, no winner, go to blades
            if (self.shot_a.dice_crit > 0 && self.shot_b.dice_crit > 0) {
                //TODO: duel blades
                break;
            }
            
            pace_number += 1;
        };
 
        (winner)
    }
}



