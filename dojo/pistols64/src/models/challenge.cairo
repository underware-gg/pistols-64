use starknet::ContractAddress;

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Challenge {
    #[key]
    pub namespace: felt252,
    pub address: ContractAddress,
    pub is_available: bool,
}
