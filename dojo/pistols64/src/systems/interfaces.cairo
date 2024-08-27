use starknet::{ContractAddress, ClassHash};
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait, Resource};

use planetary_interface::utils::systems::{get_world_contract_address};
use pistols64::systems::{
    actions::{IActionsDispatcher, IActionsDispatcherTrait},
    rng::{IRngDispatcher, IRngDispatcherTrait},
};

mod SELECTORS {
    const ACTIONS: felt252 = selector_from_tag!("pistols64-actions");
    const RNG: felt252 = selector_from_tag!("pistols64-rng");
}

#[generate_trait]
impl WorldSystemsTraitImpl of WorldSystemsTrait {
    fn actions_dispatcher(self: IWorldDispatcher) -> IActionsDispatcher {
        (IActionsDispatcher{ contract_address: get_world_contract_address(self, SELECTORS::ACTIONS) })
    }
    fn rng_dispatcher(self: IWorldDispatcher) -> IRngDispatcher {
        (IRngDispatcher{ contract_address: get_world_contract_address(self, SELECTORS::RNG) })
    }
}
