use starknet::ContractAddress;

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Planet {
    #[key]
    pub name: felt252,
    pub world_address: ContractAddress,
    pub is_available: bool,
}

#[generate_trait]
impl PlanetImpl of PlanetTrait {
}
