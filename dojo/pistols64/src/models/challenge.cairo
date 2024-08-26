use starknet::ContractAddress;
use pistols64::types::state::ChallengeState;

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Challenge {
    #[key]
    pub duel_id: u128,
    //-------------------------
    pub address_a: ContractAddress,     // Challenger wallet
    pub address_b: ContractAddress,     // Challenged wallet
    pub name_a: felt252,                // Challenger name
    pub name_b: felt252,                // Challenged name 
    pub message: felt252,               // message to challenged
    // progress and results
    pub state: ChallengeState,
    pub winner: u8,                     // 0:draw, 1:duelist_a, 2:duelist_b
}
