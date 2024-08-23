#[cfg(test)]
mod tester {
    use starknet::{ContractAddress, testing, get_caller_address};
    use core::traits::Into;
    use array::ArrayTrait;
    use debug::PrintTrait;

    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
    use dojo::utils::test::{spawn_test_world, deploy_contract};

    use planetary::models::planet::{
        planet, Planet,
    };

    use planetary::tests::component_mock::component_mock;


    fn ZERO() -> ContractAddress { starknet::contract_address_const::<0x0>() }
    fn OWNER() -> ContractAddress { starknet::contract_address_const::<0x1>() }

    fn impersonate(address: ContractAddress) {
        testing::set_contract_address(address);
        testing::set_account_contract_address(address);
    }


    //-------------------------------
    // Test world


    fn STATE() -> (IWorldDispatcher, component_mock::ContractState) {
        let world = spawn_test_world(
            ["planetary"].span(),
            [planet::TEST_CLASS_HASH].span()
        );

        let mut state = component_mock::contract_state_for_testing();
        state.world_dispatcher.write(world);

        (world, state)
    }

}
