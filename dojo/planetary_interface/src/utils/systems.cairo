use starknet::{ContractAddress, ClassHash};
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait, Resource};
use planetary_interface::utils::misc::{ZERO};

fn get_world_contract_address(world: IWorldDispatcher, selector: felt252) -> ContractAddress {
    if let Resource::Contract((_, contract_address)) = world.resource(selector) {
        (contract_address)
    } else {
        (ZERO())
    }
}

fn get_resource_type(world: IWorldDispatcher, selector: felt252) -> felt252 {
    match world.resource(selector) {
        Resource::Model => 'Model',
        Resource::Contract => 'Contract',
        Resource::Namespace => 'Namespace',
        Resource::World => 'World',
        Resource::Unregistered => 'Unregistered',
        _ => 'NONE'
    }
}
