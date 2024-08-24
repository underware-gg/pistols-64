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
    use planetary::interfaces::planetary::{
        IPlanetaryActionsDispatcher, IPlanetaryActionsDispatcherTrait,
        PlanetaryInterfaceTrait,
    };
    
    use planetary_interface::utils::misc::{WORLD};

    fn dojo_init(ref world: IWorldDispatcher) {
        let planetary_dispatcher: IPlanetaryActionsDispatcher = PlanetaryInterfaceTrait::actions_dispatcher();
        planetary_dispatcher.register('pistols64', world.contract_address);
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
