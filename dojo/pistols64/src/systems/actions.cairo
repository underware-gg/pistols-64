use starknet::ContractAddress;
use dojo::world::IWorldDispatcher;

#[dojo::interface]
trait IActions {
    fn create_challenge(ref world: IWorldDispatcher);
    fn reply_challenge(ref world: IWorldDispatcher);
    fn commit(ref world: IWorldDispatcher);
    fn reveal(ref world: IWorldDispatcher);
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
    
    use planetary_interface::utils::misc::{WORLD};

    fn dojo_init(ref world: IWorldDispatcher) {
        let planetary: PlanetaryInterface = PlanetaryInterfaceTrait::new();
        planetary.planetary_dispatcher().register(Pistols64InterfaceTrait::NAMESPACE, world.contract_address);
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

    }
}
