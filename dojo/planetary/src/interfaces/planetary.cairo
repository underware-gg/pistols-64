use starknet::{ContractAddress, ClassHash, contract_address_const};
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait, Resource};

use planetary::systems::actions::{IPlanetaryActionsDispatcher, IPlanetaryActionsDispatcherTrait};
use planetary::utils::systems::{get_world_contract_address};

#[generate_trait]
impl PlanetaryInterfaceImpl of PlanetaryInterfaceTrait {

    const ACTIONS_SELECTOR: felt252 = selector_from_tag!("planetary-planetary_actions");

    fn WORLD_CONTRACT() -> ContractAddress {
        (starknet::contract_address_const::<0x783e2bc93ef51a73a6af04907e765f83e20c68e58a2b55b4f0c4a397c51b5b5>())
    }

    //
    // dispatchers
    fn world_dispatcher() -> IWorldDispatcher {
        (IWorldDispatcher{ contract_address: Self::WORLD_CONTRACT() })
    }
    fn actions_dispatcher() -> IPlanetaryActionsDispatcher {
        (IPlanetaryActionsDispatcher{
            contract_address: get_world_contract_address(Self::world_dispatcher(), Self::ACTIONS_SELECTOR)
        })
    }
}
