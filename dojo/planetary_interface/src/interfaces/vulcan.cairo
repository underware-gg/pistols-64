use core::debug::PrintTrait;
use starknet::{ContractAddress, ClassHash, contract_address_const};
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait, Resource};

use planetary_interface::utils::systems::{get_world_contract_address};
use planetary_interface::interfaces::planetary::{
    PlanetaryInterface, PlanetaryInterfaceTrait,
    IPlanetaryActionsDispatcher, IPlanetaryActionsDispatcherTrait,
};

#[starknet::interface]
trait IVulcanSalute<TState> {
    fn live_long(ref self: TState) -> felt252;
}

#[derive(Copy, Drop)]
struct VulcanInterface {
    world: IWorldDispatcher
}

#[generate_trait]
impl VulcanInterfaceImpl of VulcanInterfaceTrait {
    
    const NAMESPACE: felt252 = 'vulcan';
    const SALUTE_SELECTOR: felt252 = selector_from_tag!("vulcan-salute");

    // uses default hard-coded address
    fn new() -> VulcanInterface {
        let planetary: PlanetaryInterface = PlanetaryInterfaceTrait::new();
        let world_address: ContractAddress = planetary.dispatcher().get_world_address(Self::NAMESPACE);
        (VulcanInterface{
            world: IWorldDispatcher{contract_address: world_address}
        })
    }

    // use custom planetary world address for testing
    fn new_custom(planetary_world_address: ContractAddress) -> VulcanInterface {
        let planetary: PlanetaryInterface = PlanetaryInterfaceTrait::new_custom(planetary_world_address);
        let world_address: ContractAddress = planetary.dispatcher().get_world_address(Self::NAMESPACE);
        (VulcanInterface{
            world: IWorldDispatcher{contract_address: world_address}
        })
    }

    //
    // dispatchers
    fn dispatcher(self: VulcanInterface) -> IVulcanSaluteDispatcher {
        (IVulcanSaluteDispatcher{
            contract_address: get_world_contract_address(self.world, Self::SALUTE_SELECTOR)
        })
    }
}
