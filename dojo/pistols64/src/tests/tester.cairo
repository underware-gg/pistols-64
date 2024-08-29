#[cfg(test)]
mod tester {
    use starknet::{ContractAddress, testing, get_caller_address};
    use core::traits::Into;
    use array::ArrayTrait;
    use debug::PrintTrait;

    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
    use dojo::utils::test::{spawn_test_world, deploy_contract};

    use pistols64::utils::store::{Store, StoreTrait};
    use pistols64::systems::actions::{actions, IActionsDispatcher, IActionsDispatcherTrait};
    use pistols64::systems::rng::{rng};
    use pistols64::tests::mock_rng::{
        rng as mock_rng,
        IRngDispatcher,
        IRngDispatcherTrait,
        salt_value, SaltValue,
    };

    use pistols64::models::{
        challenge::{challenge, Challenge},
        round::{round, Round},
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

    mod FLAGS {
        const MOCK_RNG: u8  = 0b000001;
    }

    #[derive(Copy, Drop)]
    struct Systems {
        world: IWorldDispatcher,
        actions: IActionsDispatcher,
        rng: IRngDispatcher,
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
            round::TEST_CLASS_HASH,
            salt_value::TEST_CLASS_HASH,
        ];

        let deploy_mock_rng = (flags & FLAGS::MOCK_RNG) != 0;

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
        let rng = IRngDispatcher{ contract_address:
            {
                let class_hash = if (deploy_mock_rng) {mock_rng::TEST_CLASS_HASH} else {rng::TEST_CLASS_HASH};
                let address = deploy_system(world, 'rng', class_hash);
                world.grant_owner(dojo::utils::bytearray_hash(@"pistols64"), address);
                (address)
            }
        };
        
        impersonate(OWNER());

        let store: Store = StoreTrait::new(world);

        (Systems{
            world,
            actions: pistols64,
            rng,
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
    fn next_block() -> (u64, u64) {
        elapse_timestamp(INITIAL_STEP)
    }

    //
    // execute calls
    //

    // ::actions
    fn execute_create_challenge(actions: IActionsDispatcher, sender: ContractAddress, name_a: felt252, name_b: felt252, message: felt252) -> u128 {
        impersonate(sender);
        let duel_id: u128 = actions.create_challenge(name_a, name_b, message);
        next_block();
        (duel_id)
    }
    fn execute_move(actions: IActionsDispatcher, sender: ContractAddress, duel_id: u128, round_number: u8, duelist_name: felt252, moves: Span<u8>) {
        impersonate(sender);
        actions.move(duel_id, round_number, duelist_name, moves);
        next_block();
    }
}