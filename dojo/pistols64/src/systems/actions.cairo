use starknet::{ContractAddress};
use dojo::world::IWorldDispatcher;

#[dojo::interface]
trait IActions {
    fn create_challenge(ref world: IWorldDispatcher, duelist_name_a: felt252, duelist_name_b: felt252, message: felt252) -> u128;
    fn move(ref world: IWorldDispatcher, duel_id: u128, round_number: u8, duelist_name: felt252, moves: Span<u8>);

    // test vulcan interface
    fn live_long(world: @IWorldDispatcher) -> felt252;
}

#[dojo::contract]
mod actions {
    use super::IActions;
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
    use planetary_interface::utils::misc::{WORLD};

    use pistols64::models::{
        challenge::{Challenge, ChallengeTrait},
        round::{Round, RoundTrait},
    };
    use pistols64::types::{
        state::{ChallengeState},
    };
    use pistols64::types::cards::{
        paces::{PacesCard, PacesCardTrait},
        tactics::{TacticsCard, TacticsCardTrait},
        blades::{BladesCard, BladesCardTrait},
        env::{EnvCard, EnvCardTrait},
    };
    use pistols64::utils::store::{Store, StoreTrait};
    use pistols64::utils::seeder::{make_seed, felt_to_u128};
    
    mod Errors {
        const InvalidNameA: felt252 = 'PISTOLS64: Invalid name A';
        const InvalidNameB: felt252 = 'PISTOLS64: Invalid name B';
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
            assert(felt_to_u128(duelist_name_a) > 0xffffff, Errors::InvalidNameA); // check if name len is > 3
            assert(felt_to_u128(duelist_name_b) > 0xffffff, Errors::InvalidNameB); // check if name len is > 3
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
            println!("new challenge: [{}]", duel_id);
            (duel_id)
        }

        fn move(ref world: IWorldDispatcher, duel_id: u128, round_number: u8, duelist_name: felt252, moves: Span<u8>) {
            // validate challenge
            let store: Store = StoreTrait::new(world);
            let challenge: Challenge = store.get_challenge(duel_id);
            assert(challenge.state != ChallengeState::Null, Errors::InvalidChallenge);
            assert(challenge.state == ChallengeState::InProgress, Errors::InvalidChallengeState);

            // validate duelist
            let duelist_number: u8 = challenge.duelist_number(duelist_name);
            assert(duelist_number > 0, Errors::InvalidDuelist);

            // validate caller
            let caller: ContractAddress = starknet::get_caller_address();
            assert(caller == (if (duelist_number == 1) {challenge.address_a} else {challenge.address_b}), Errors::InvalidCaller);
        }

        // test with sozo:
        // sozo call pistols64-actions live_long
        fn live_long(world: @IWorldDispatcher) -> felt252 {
            WORLD(world);
            let vulcan: IVulcanSaluteDispatcher = VulcanInterfaceTrait::new().dispatcher();
            (vulcan.live_long())
        }
    }
}
