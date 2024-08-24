use starknet::{ContractAddress, ClassHash};
use dojo::world::IWorldDispatcher;

// #[starknet::interface]
// trait IPlanetaryMock<TState> {
//     fn initializer(ref self: TState, initial_supply: u256, recipient: ContractAddress);
// }

#[dojo::contract]
mod mock_component {
    use planetary_interface::components::planetary::{planetary_component};

    component!(path: planetary_component, storage: planetary, event: PlaneraryEvent);

    #[abi(embed_v0)]
    impl PlanetaryImpl = planetary_component::PlanetaryImpl<ContractState>;

    // impl PlanetaryInternalImpl = planetary_component::InternalImpl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        planetary: planetary_component::Storage,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        PlaneraryEvent: planetary_component::Event,
    }

    // #[abi(embed_v0)]
    // impl InitializerImpl of super::IPlanetaryMock<ContractState> {
    //     fn initializer(ref self: ContractState, initial_supply: u256, recipient: ContractAddress,) {
    //         // set balance for recipient
    //         self.erc20_balance.update_balance(recipient, 0, initial_supply);
    //     }
    // }
}
