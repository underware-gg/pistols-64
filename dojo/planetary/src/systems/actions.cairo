use starknet::ContractAddress;
use dojo::world::IWorldDispatcher;

// Interfaces

#[dojo::interface]
trait IPlanetaryActions {
    fn register(ref world: IWorldDispatcher, name: felt252, world_address: ContractAddress);
    fn unregister(ref world: IWorldDispatcher, name: felt252);
    fn get_world_address(world: @IWorldDispatcher, name: felt252) -> ContractAddress;
}

// Contracts

#[dojo::contract]
mod planetary_actions {
    use super::IPlanetaryActions;
    use starknet::ContractAddress;
    use planetary::models::planet::{
        Planet, PlanetTrait,
        PlanetStore, PlanetModelImpl,
    };

    mod Errors {
        const PLANET_UNAVAILABLE: felt252 = 'PLANETARY: Unavailable';
    }

    #[abi(embed_v0)]
    impl ActionsImpl of super::IPlanetaryActions<ContractState> {
        fn register(ref world: IWorldDispatcher, name: felt252, world_address: ContractAddress) {
            let planet = Planet {
                name,
                world_address,
                is_available: true,
            };
            planet.set(world);
        }

        fn unregister(ref world: IWorldDispatcher, name: felt252) {
            let mut planet: Planet = PlanetStore::get(world, name);
            assert(planet.is_available == true, Errors::PLANET_UNAVAILABLE);
            planet.is_available = false;
            planet.set(world);
        }

        fn get_world_address(world: @IWorldDispatcher, name: felt252) -> ContractAddress {
            let planet: Planet = PlanetStore::get(world, name);
            (planet.world_address)
        }
    }

    #[generate_trait]
    impl ActionsInternalImpl of ActionsInternalTrait {
        fn assert_caller_is_contract(ref world: IWorldDispatcher) {
        }
    }
}
