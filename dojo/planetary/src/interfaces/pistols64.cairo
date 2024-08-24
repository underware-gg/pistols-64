use starknet::{ContractAddress, ClassHash, contract_address_const};
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait, Resource};

use planetary::utils::systems::{get_world_contract_address};

#[starknet::interface]
trait IPistols64Actions<TState> {
    fn create_challenge(ref self: TState);
    fn reply_challenge(ref self: TState);
    fn commit(ref self: TState);
    fn reveal(ref self: TState);
}

#[derive(Copy, Drop)]
struct Pistols64Interface {
    world: IWorldDispatcher
}

#[generate_trait]
impl Pistols64InterfaceImpl of Pistols64InterfaceTrait {
    
    const NAMESPACE: felt252 = 'pistols64';
    const ACTIONS_SELECTOR: felt252 = selector_from_tag!("pistols64-actions");

    fn new(world_address: ContractAddress) -> Pistols64Interface {
        (Pistols64Interface{ 
            world: IWorldDispatcher{contract_address: world_address}
        })
    }

    //
    // dispatchers
    fn actions_dispatcher(self: Pistols64Interface) -> IPistols64ActionsDispatcher {
        (IPistols64ActionsDispatcher{
            contract_address: get_world_contract_address(self.world, Self::ACTIONS_SELECTOR)
        })
    }
}
