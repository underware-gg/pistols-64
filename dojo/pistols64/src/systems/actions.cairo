use starknet::ContractAddress;
use dojo::world::IWorldDispatcher;

#[dojo::interface]
trait IActions {
    fn create_challenge(ref world: IWorldDispatcher);
    fn reply_challenge(ref world: IWorldDispatcher);
    fn commit(ref world: IWorldDispatcher);
    fn reveal(ref world: IWorldDispatcher);

    fn live_long(world: @IWorldDispatcher) -> felt252;
}

#[dojo::contract]
mod actions {
    use super::IActions;

    use pistols64::models::challenge::{Challenge};
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

    fn dojo_init(ref world: IWorldDispatcher) {
        let planetary: PlanetaryInterface = PlanetaryInterfaceTrait::new();
        planetary.dispatcher().register(Pistols64InterfaceTrait::NAMESPACE, world.contract_address);
    }


    #[abi(embed_v0)]
    impl ActionsImpl of IActions<ContractState> {
        fn create_challenge(ref world: IWorldDispatcher) {
            WORLD(world);
        }

        fn reply_challenge(ref world: IWorldDispatcher) {
            WORLD(world);
        }

        fn commit(ref world: IWorldDispatcher) {
            WORLD(world);
        }

        fn reveal(ref world: IWorldDispatcher) {
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
