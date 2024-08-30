use starknet::{ContractAddress};
use dojo::world::IWorldDispatcher;
use pistols64::models::challenge::{ChallengeResults};

#[dojo::interface]
trait IActions {
    fn create_challenge(ref world: IWorldDispatcher, duelist_name_a: felt252, duelist_name_b: felt252, message: felt252) -> u128;
    fn move(ref world: IWorldDispatcher, duel_id: u128, round_number: u8, duelist_name: felt252, moves: Span<u8>);
    fn get_challenge_results(world: @IWorldDispatcher, duel_id: u128) -> ChallengeResults;

    // test vulcan interface
    fn live_long(world: @IWorldDispatcher) -> felt252;

    // calls to TOT
    fn live_fast_die_jung(ref world: IWorldDispatcher, cmd: Array<ByteArray>) -> Array<ByteArray>;
}


#[dojo::contract]
mod actions {
    use super::IActions;
    use core::debug::PrintTrait;
    use starknet::{ContractAddress};

    use planetary_interface::interfaces::planetary::{
        PlanetaryInterface, PlanetaryInterfaceTrait,
        IPlanetaryActionsDispatcherTrait,
    };
    use planetary_interface::interfaces::pistols64::{
        Pistols64Interface, Pistols64InterfaceTrait,
    };
    use planetary_interface::interfaces::vulcan::{
        VulcanInterface, VulcanInterfaceTrait,
        IVulcanSaluteDispatcher, IVulcanSaluteDispatcherTrait,
    };
    
    // TOT calls
    use planetary_interface::interfaces::tot::{
        ToTInterface, ToTInterfaceTrait,
        IToTActionsDispatcher, IToTActionsDispatcherTrait,
    };

    use planetary_interface::utils::misc::{WORLD};

    use pistols64::models::{
        challenge::{Challenge, ChallengeTrait, ChallengeResults},
        round::{Round, RoundTrait, Shot, ShotTrait},
    };
    use pistols64::types::{
        state::{ChallengeState, ChallengeStateTrait},
    };
    use pistols64::types::cards::{
        paces::{PacesCard, PacesCardTrait},
        tactics::{TacticsCard, TacticsCardTrait},
        blades::{BladesCard, BladesCardTrait},
        env::{EnvCard, EnvCardTrait},
    };
    use pistols64::systems::rng::{Rng, RngTrait};
    use pistols64::utils::store::{Store, StoreTrait};
    use pistols64::utils::seeder::{make_seed, felt_to_u128};
    
    mod Errors {
        const InvalidNameA: felt252 = 'PISTOLS64: Invalid name A';
        const InvalidNameB: felt252 = 'PISTOLS64: Invalid name B';
        const InvalidNames: felt252 = 'PISTOLS64: Names are equal';
        const InvalidChallenge: felt252 = 'PISTOLS64: Invalid challenge';
        const InvalidChallengeState: felt252 = 'PISTOLS64: Invalid state';
        const InvalidDuelist: felt252 = 'PISTOLS64: Invalid duelist';
        const InvalidCaller: felt252 = 'PISTOLS64: Invalid caller';
    }

    fn dojo_init(ref world: IWorldDispatcher) {
        let planetary: PlanetaryInterface = PlanetaryInterfaceTrait::new();
        planetary.dispatcher().register(Pistols64InterfaceTrait::NAMESPACE, world.contract_address);
    }


    #[abi(embed_v0)]
    impl ActionsImpl of IActions<ContractState> {
        fn create_challenge(ref world: IWorldDispatcher, duelist_name_a: felt252, duelist_name_b: felt252, message: felt252) -> u128 {
            assert(felt_to_u128(duelist_name_a) > 0xffff, Errors::InvalidNameA); // check if name len is >= 3
            assert(felt_to_u128(duelist_name_b) > 0xffff, Errors::InvalidNameB); // check if name len is >= 3
            assert(duelist_name_a != duelist_name_b, Errors::InvalidNames);
            let caller: ContractAddress = starknet::get_caller_address();
            let duel_id: u128 = make_seed(caller, world.uuid());
            let challenge = Challenge {
                duel_id,
                address_a: caller,
                address_b: caller,
                duelist_name_a,
                duelist_name_b,
                message,
                state: ChallengeState::InProgress,
                winner: 0,
            };
            let store: Store = StoreTrait::new(world);
            store.set_challenge(challenge);
            // println!("new challenge: [{}]", duel_id);
            (duel_id)
        }

        fn move(ref world: IWorldDispatcher, duel_id: u128, round_number: u8, duelist_name: felt252, moves: Span<u8>) {
            // validate challenge
            let store: Store = StoreTrait::new(world);
            let mut challenge: Challenge = store.get_challenge(duel_id);
            assert(challenge.state != ChallengeState::Null, Errors::InvalidChallenge);
            assert(challenge.state == ChallengeState::InProgress, Errors::InvalidChallengeState);

            // validate duelist
            let duelist_number: u8 = challenge.duelist_number(duelist_name);
            assert(duelist_number > 0, Errors::InvalidDuelist);

            // validate caller
            let caller: ContractAddress = starknet::get_caller_address();
            assert(caller == (if (duelist_number == 1) {challenge.address_a} else {challenge.address_b}), Errors::InvalidCaller);

            // set moves
            let mut round: Round = store.get_round(duel_id, round_number);
            if (duelist_number == 1) {
                round.shot_a.initialize(moves);
            } else {
                round.shot_b.initialize(moves); 
            }
            
            // time to duel!
            if (round.shot_a.card_paces != PacesCard::Null && round.shot_b.card_paces != PacesCard::Null) {
                let mut rng: Rng = RngTrait::new(world, duel_id);
                // duel and decide winner
                challenge.finalize(ref rng, ref round);
                // save challenge
                store.set_challenge(challenge);
            }

            // save round
// println!("Shot A {} / {}", round.shot_a.dice_crit, round.shot_a.final_chances);
// println!("Shot B {} / {}", round.shot_b.dice_crit, round.shot_b.final_chances);
            store.set_round(round);
        }

        fn get_challenge_results(world: @IWorldDispatcher, duel_id: u128) -> ChallengeResults {
            let store: Store = StoreTrait::new(world);
            let challenge: Challenge = store.get_challenge(duel_id);
            let round: Round = store.get_round(duel_id, 1);

            (ChallengeResults {
                duel_id,
                duelist_name_a: challenge.duelist_name_a,
                duelist_name_b: challenge.duelist_name_b,
                message: challenge.message,
                moves_a: [round.shot_a.card_paces.into(), round.shot_a.card_dodge.into()].span(),
                moves_b: [round.shot_b.card_paces.into(), round.shot_b.card_dodge.into()].span(),
                is_finished: challenge.state.is_finished(),
                winner: challenge.winner,
            })
        }
        // test with sozo:
        // sozo call pistols64-actions live_long
        fn live_long(world: @IWorldDispatcher) -> felt252 {
            WORLD(world);
            let vulcan: IVulcanSaluteDispatcher = VulcanInterfaceTrait::new().dispatcher();
            (vulcan.live_long())
        }

        // call out to ToT via the interface
        fn live_fast_die_jung(ref world: IWorldDispatcher, cmd: Array<ByteArray>) -> Array<ByteArray> {
            WORLD(world);
            let tot: IToTActionsDispatcher = ToTInterfaceTrait::new().dispatcher();
            // println!("cmd: {:?}", cmd);
            (tot.command_shoggoth(23, cmd))
        }
    }
}
