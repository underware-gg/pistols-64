use starknet::{ContractAddress, ClassHash, contract_address_const};
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait, Resource};

use planetary_interface::utils::systems::{get_world_contract_address};
use planetary_interface::interfaces::planetary::{
    PlanetaryInterface, PlanetaryInterfaceTrait,
    IPlanetaryActionsDispatcher, IPlanetaryActionsDispatcherTrait,
};

#[starknet::interface]
trait IPistols64Actions<TState> {
    fn create_challenge(ref self: TState, duelist_name_a: felt252, duelist_name_b: felt252, message: felt252) -> u128;
    fn move(ref self: TState, duel_id: u128, round_number: u8, duelist_name: felt252, moves: Span<felt252>);
}

#[derive(Copy, Drop)]
struct Pistols64Interface {
    world: IWorldDispatcher
}

#[generate_trait]
impl Pistols64InterfaceImpl of Pistols64InterfaceTrait {
    
    const NAMESPACE: felt252 = 'pistols64';
    const ACTIONS_SELECTOR: felt252 = selector_from_tag!("pistols64-actions");

    fn new() -> Pistols64Interface {
        let world_address: ContractAddress = PlanetaryInterfaceTrait::new().dispatcher().get_world_address(Self::NAMESPACE);
        (Pistols64Interface{
            world: IWorldDispatcher{contract_address: world_address}
        })
    }

    //
    // dispatchers
    fn dispatcher(self: Pistols64Interface) -> IPistols64ActionsDispatcher {
        (IPistols64ActionsDispatcher{
            contract_address: get_world_contract_address(self.world, Self::ACTIONS_SELECTOR)
        })
    }
}
