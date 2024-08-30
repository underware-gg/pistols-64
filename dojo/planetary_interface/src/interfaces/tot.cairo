use starknet::{ContractAddress, ClassHash, contract_address_const};
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait, Resource};

use planetary_interface::utils::systems::{get_world_contract_address};
use planetary_interface::interfaces::planetary::{
    PlanetaryInterface, PlanetaryInterfaceTrait,
    IPlanetaryActionsDispatcher, IPlanetaryActionsDispatcherTrait,
};

#[starknet::interface]
trait IToTActions<TState> {
    fn command_shoggoth(ref self: TState, victim: felt252, wish: Array<ByteArray>) -> Array<ByteArray>;
}

#[derive(Copy, Drop)]
struct ToTInterface {
    world: IWorldDispatcher
}

#[generate_trait]
impl ToTInterfaceImpl of ToTInterfaceTrait {
    
    const NAMESPACE: felt252 = 'the_oruggin_trail';
    // note the `name_space-mod` naming convention
    const ACTIONS_SELECTOR: felt252 = selector_from_tag!("the_oruggin_trail-meatpuppet");

    fn new() -> ToTInterface {
        let world_address: ContractAddress = PlanetaryInterfaceTrait::new().dispatcher().get_world_address(Self::NAMESPACE);
        (ToTInterface{
            world: IWorldDispatcher{contract_address: world_address}
        })
    }

    //
    // dispatchers
    fn dispatcher(self: ToTInterface) -> IToTActionsDispatcher {
        (IToTActionsDispatcher{
            contract_address: get_world_contract_address(self.world, Self::ACTIONS_SELECTOR)
        })
    }

}
 