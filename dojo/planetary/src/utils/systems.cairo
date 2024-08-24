use starknet::{ContractAddress, ClassHash};
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait, Resource};
use planetary::utils::misc::{ZERO};

fn get_world_contract_address(world: IWorldDispatcher, selector: felt252) -> ContractAddress {
    if let Resource::Contract((_, contract_address)) = world.resource(selector) {
        (contract_address)
    } else {
        (ZERO())
    }
}
