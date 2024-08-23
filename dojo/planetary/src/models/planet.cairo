use starknet::ContractAddress;

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Planet {
    #[key]
    pub namespace: felt252,
    pub address: ContractAddress,
    pub is_available: bool,
}

#[generate_trait]
impl PlanetTraitImpl of PlanetTrait {
}
