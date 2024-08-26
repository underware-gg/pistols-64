use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

use pistols64::models::{
    challenge::{Challenge, ChallengeStore, ChallengeEntity, ChallengeEntityStore},
    round::{Round, RoundStore},
};

#[derive(Copy, Drop)]
struct Store {
    world: IWorldDispatcher,
}

#[generate_trait]
impl StoreImpl of StoreTrait {
    #[inline]
    fn new(world: IWorldDispatcher) -> Store {
        (Store { world: world })
    }

    //
    // Getters
    //

    #[inline(always)]
    fn get_challenge(self: Store, duel_id: u128) -> Challenge {
        // (get!(self.world, duel_id, (Challenge)))
        // dojo::model::ModelEntity::<ChallengeEntity>::get(self.world, 1); // OK
        // let mut challenge_entity = ChallengeEntityStore::get(self.world, 1); // OK
        // challenge_entity.update(self.world); // ERROR
        (ChallengeStore::get(self.world, duel_id))
    }

    #[inline(always)]
    fn get_round(self: Store, duel_id: u128, round_number: u8) -> Round {
        (RoundStore::get(self.world, duel_id, round_number))
    }

    //
    // Setters
    //

    #[inline(always)]
    fn set_challenge(self: Store, challenge: Challenge) {
        // set!(self.world, (challenge));
        // challenge.set(world); // ERROR
        dojo::model::Model::<Challenge>::set(@challenge, self.world);
    }

    #[inline(always)]
    fn set_round(self: Store, round: Round) {
        dojo::model::Model::<Round>::set(@round, self.world);
    }

}