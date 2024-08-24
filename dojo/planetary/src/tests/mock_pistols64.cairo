use starknet::{ContractAddress};

#[dojo::interface]
trait IPistols64 {
    fn init(world: @IWorldDispatcher);
}

#[dojo::contract]
#[namespace("pistols64")]
mod actions {
    use super::IPistols64;
    use debug::PrintTrait;
    use core::traits::Into;
    use starknet::{ContractAddress, get_contract_address, get_caller_address, get_tx_info};
    
    use planetary_interface::interfaces::planetary::{
        IPlanetaryActionsDispatcher, IPlanetaryActionsDispatcherTrait,
        PlanetaryInterfaceTrait,
    };

    #[abi(embed_v0)]
    impl IPistols64Impl of IPistols64<ContractState> {
        fn init(world: @IWorldDispatcher) {
            let planetary_dispatcher: IPlanetaryActionsDispatcher = PlanetaryInterfaceTrait::actions_dispatcher();
            planetary_dispatcher.register('pistols64', world.contract_address);
        }
    }
}
