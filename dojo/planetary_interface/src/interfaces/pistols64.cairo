use starknet::{ContractAddress, ClassHash, contract_address_const};
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait, Resource};

use planetary_interface::utils::systems::{get_world_contract_address};
use planetary_interface::interfaces::planetary::{
    PlanetaryInterface, PlanetaryInterfaceTrait,
    IPlanetaryActionsDispatcher, IPlanetaryActionsDispatcherTrait,
};

// for planetary interface
#[derive(Copy, Drop, Serde)]
struct ChallengeResults {
    duel_id: u128,
    duelist_name_a: felt252,
    duelist_name_b: felt252,
    message: felt252,
    moves_a: Span<u8>,
    moves_b: Span<u8>,
    is_finished: bool,
    winner: u8,     // 0 (draw), 1 (A wins), 2 (B wins)
}

#[starknet::interface]
trait IPistols64Actions<TState> {

    // creates a new duel, ready to be played
    // duelist_name_a: name of duelist A
    // duelist_name_b: name of duelist B
    // message: the beef   
    fn create_challenge(ref self: TState, duelist_name_a: felt252, duelist_name_b: felt252, message: felt252) -> u128;
    
    // makes a move in an existing duel
    // has to be called twice, once for each duelist (duelist_name)
    //  duel_id: id of the duel to play (returned from create_challenge())
    //  round_number: always 1 (possible to be extended to more rounds in the future)
    //  duelist_name: name of the duelist making the move
    //  moves: an array containing the moves/card to play: [paces, dodge]
    //         (each is a number from 1 to 10, where players shoots and where they dodge)
    fn move(ref self: TState, duel_id: u128, round_number: u8, duelist_name: felt252, moves: Span<u8>);

    // get the current state of a duel
    fn get_challenge_results(self: @TState, duel_id: u128) -> ChallengeResults;
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
