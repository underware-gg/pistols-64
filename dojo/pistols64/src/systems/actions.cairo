use starknet::{ContractAddress};
use dojo::world::IWorldDispatcher;

#[dojo::interface]
trait IActions {
    fn create_challenge(ref world: IWorldDispatcher, name_a: felt252, name_b: felt252, message: felt252) -> u128;
    fn move(ref world: IWorldDispatcher, name: felt252, moves: Array<felt252>);

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

    use pistols64::models::challenge::{Challenge};
    use pistols64::types::state::{ChallengeState};
    use pistols64::utils::store::{Store, StoreTrait};
    use pistols64::utils::seeder::{make_seed};

    fn dojo_init(ref world: IWorldDispatcher) {
        let planetary: PlanetaryInterface = PlanetaryInterfaceTrait::new();
        planetary.dispatcher().register(Pistols64InterfaceTrait::NAMESPACE, world.contract_address);
    }


    #[abi(embed_v0)]
    impl ActionsImpl of IActions<ContractState> {
        fn create_challenge(ref world: IWorldDispatcher, name_a: felt252, name_b: felt252, message: felt252) -> u128 {
            let caller: ContractAddress = starknet::get_caller_address();
            let duel_id: u128 = make_seed(caller, world.uuid());
            let challenge = Challenge {
                duel_id,
                address_a: caller,
                address_b: caller,
                name_a,
                name_b,
                message,
                state: ChallengeState::InProgress,
                winner: 0,
            };
            let store: Store = StoreTrait::new(world);
            store.set_challenge(challenge);
            (duel_id)
        }

        fn move(ref world: IWorldDispatcher, name: felt252, moves: Array<felt252>) {
            WORLD(world);
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
