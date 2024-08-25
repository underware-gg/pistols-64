use starknet::{ContractAddress};

#[dojo::interface]
trait IVulcan {
    fn init(world: @IWorldDispatcher, planetary_world_address: ContractAddress);
    fn live_long(world: @IWorldDispatcher) -> felt252;
}

#[dojo::contract(namespace: "vulcan", nomapping: true)]
mod salute {
    use super::IVulcan;
    use debug::PrintTrait;
    use core::traits::Into;
    use starknet::{ContractAddress, get_contract_address, get_caller_address, get_tx_info};
    
    use planetary_interface::interfaces::planetary::{
        PlanetaryInterface, PlanetaryInterfaceTrait,
        IPlanetaryActionsDispatcher, IPlanetaryActionsDispatcherTrait,
    };
    use planetary_interface::interfaces::vulcan::{
        VulcanInterface, VulcanInterfaceTrait,
    };
    use planetary_interface::utils::misc::{WORLD};

    fn dojo_init(ref world: IWorldDispatcher) {
        let planetary: PlanetaryInterface = PlanetaryInterfaceTrait::new();
        planetary.dispatcher().register(VulcanInterfaceTrait::NAMESPACE, world.contract_address);
    }

    #[abi(embed_v0)]
    impl IVulcanImpl of IVulcan<ContractState> {
        
        // custom init for testing only
        fn init(world: @IWorldDispatcher, planetary_world_address: ContractAddress) {
            let planetary: PlanetaryInterface = PlanetaryInterfaceTrait::new_custom(planetary_world_address);
            planetary.dispatcher().register(VulcanInterfaceTrait::NAMESPACE, world.contract_address);
        }

        // salute
        fn live_long(world: @IWorldDispatcher) -> felt252 {
            WORLD(world);
            ('and_prosper')
        }
    }
}
