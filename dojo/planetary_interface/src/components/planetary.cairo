use starknet::ContractAddress;

#[starknet::interface]
trait IPlanetary<TState> {
    fn ping(self: @TState) -> felt252;
    // fn get(self: @ComponentState<TContractState>, world: IWorldDispatcher);
}

#[starknet::component]
mod planetary_component {
    use super::IPlanetary;

    use core::debug::PrintTrait;
    use starknet::ContractAddress;
    use starknet::info::{get_caller_address, get_block_timestamp};

    use dojo::world::{
        IWorldDispatcher, IWorldDispatcherTrait,
        IWorldProvider, IWorldProviderDispatcher,
    };

    use planetary_interface::utils::misc::{WORLD};

    // Storage

    #[storage]
    struct Storage {}

    // Events

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {}

    #[embeddable_as(PlanetaryImpl)]
    impl Planetary<
        TContractState,
        +HasComponent<TContractState>,
        +IWorldProvider<TContractState>,
        +Drop<TContractState>,
    > of IPlanetary<ComponentState<TContractState>> {
        fn ping(self: @ComponentState<TContractState>) -> felt252 {
            'pong'
        }

        // fn get(self: @ComponentState<TContractState>, world: IWorldDispatcher) {
        // }
    }
}