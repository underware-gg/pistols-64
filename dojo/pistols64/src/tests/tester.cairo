#[cfg(test)]
mod tester {
    use starknet::{ContractAddress, testing, get_caller_address};
    use core::traits::Into;
    use array::ArrayTrait;
    use debug::PrintTrait;

    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
    use dojo::utils::test::{spawn_test_world, deploy_contract};

use pistols64::utils::store::{Store, StoreTrait};
    use pistols64::systems::actions::{
        actions, IActionsDispatcher, IActionsDispatcherTrait
    };
    use pistols64::models::{
        challenge::{challenge, Challenge},
    };

    fn ZERO() -> ContractAddress { starknet::contract_address_const::<0x0>() }
    fn OWNER() -> ContractAddress { starknet::contract_address_const::<0x1>() }
    fn OTHER() -> ContractAddress { starknet::contract_address_const::<0x2>() }

    // set_contract_address : to define the address of the calling contract,
    // set_account_contract_address : to define the address of the account used for the current transaction.
    fn impersonate(address: ContractAddress) {
        testing::set_contract_address(address);
        testing::set_account_contract_address(address);
    }

    const INITIAL_TIMESTAMP: u64 = 0x100000000;
    const INITIAL_STEP: u64 = 0x10;

    mod flags {
        const FLAG: u8 = 0b000001;
    }

    #[derive(Copy, Drop)]
    struct Systems {
        world: IWorldDispatcher,
        actions: IActionsDispatcher,
        store: Store,
    }

    //-------------------------------
    // Test world

    #[inline(always)]
    fn deploy_system(world: IWorldDispatcher, salt: felt252, class_hash: felt252) -> ContractAddress {
        let contract_address = world.deploy_contract(salt, class_hash.try_into().unwrap());
        (contract_address)
    }

    fn setup_world(flags: u8) -> Systems {
        let mut models = array![
            challenge::TEST_CLASS_HASH,
        ];

        // setup testing
        testing::set_block_number(1);
        testing::set_block_timestamp(INITIAL_TIMESTAMP);

        // deploy world
        let world: IWorldDispatcher = spawn_test_world(["pistols64"].span(),  models.span());
        world.grant_owner(dojo::utils::bytearray_hash(@"pistols64"), OWNER());
// world.contract_address.print();

        // deploy systems
        let pistols64 = IActionsDispatcher{ contract_address:
            {
                let address = deploy_system(world, 'actions', actions::TEST_CLASS_HASH);
                world.grant_owner(dojo::utils::bytearray_hash(@"pistols64"), address);
                (address)
            }
        };
        // if (pistols64.contract_address.is_non_zero()) {
        //     pistols64.init();
        // }
        
        impersonate(OWNER());

        let store: Store = StoreTrait::new(world);

        (Systems{
            world,
            actions:pistols64,
            store,
        })
    }

    fn elapse_timestamp(delta: u64) -> (u64, u64) {
        let block_info = starknet::get_block_info().unbox();
        let new_block_number = block_info.block_number + 1;
        let new_block_timestamp = block_info.block_timestamp + delta;
        testing::set_block_number(new_block_number);
        testing::set_block_timestamp(new_block_timestamp);
        (new_block_number, new_block_timestamp)
    }

    #[inline(always)]
    fn get_block_number() -> u64 {
        (starknet::get_block_info().unbox().block_number)
    }

    #[inline(always)]
    fn get_block_timestamp() -> u64 {
        (starknet::get_block_info().unbox().block_timestamp)
    }

    #[inline(always)]
    fn _next_block() -> (u64, u64) {
        elapse_timestamp(INITIAL_STEP)
    }

    //
    // execute calls
    //

    // ::actions
    fn execute_create_challenge(actions: IActionsDispatcher, sender: ContractAddress, name_a: felt252, name_b: felt252, message: felt252) -> u128 {
        impersonate(sender);
        let duel_id: u128 = actions.create_challenge(name_a, name_b, message);
        _next_block();
        (duel_id)
    }
}