// use debug::PrintTrait;
use starknet::{ContractAddress};

// https://github.com/starkware-libs/cairo/blob/main/corelib/src/integer.cairo
// https://github.com/smartcontractkit/chainlink-starknet/blob/develop/contracts/src/utils.cairo
use integer::{u128s_from_felt252, U128sFromFelt252Result};

// https://github.com/starkware-libs/cairo/blob/main/corelib/src/starknet/info.cairo
use starknet::get_block_info;

// https://github.com/starkware-libs/cairo/blob/main/corelib/src/pedersen.cairo
extern fn pedersen(a: felt252, b: felt252) -> felt252 implicits(Pedersen) nopanic;

// alternative:
// https://github.com/dojoengine/starter-rpg/blob/main/contracts/src/helpers/seeder.cairo
// https://github.com/starkware-libs/cairo/blob/main/corelib/src/poseidon.cairo
use core::poseidon::{PoseidonTrait, HashState};


fn make_seed(caller: ContractAddress, uuid: usize) -> u128 {
    let hash: felt252 = hash_values([
        make_block_hash(),
        caller.into(),
        uuid.into(),
    ].span());
    (felt_to_u128(hash))
}

fn make_block_hash() -> felt252 {
    let block_info = get_block_info().unbox();
    let hash: felt252 = hash_values([
        block_info.block_number.into(),
        block_info.block_timestamp.into(),
    ].span());
    (hash)
}

fn hash_values(values: Span<felt252>) -> felt252 {
    assert(values.len() > 0, 'hash_values() has no values!');
    if (values.len() == 1) {
        (pedersen(*values[0], *values[0]))
    } else {
        let mut result = pedersen(*values[0], *values[1]);
        let mut index: usize = 2;
        while (index < values.len()) {
            result = pedersen(result, *values[index]);
            index += 1;
        };
        (result)
    }
}

fn felt_to_u128(value: felt252) -> u128 {
    match u128s_from_felt252(value) {
        U128sFromFelt252Result::Narrow(x) => x,
        U128sFromFelt252Result::Wide((_, x)) => x,
    }
}


//----------------------------------------
// Unit  tests
//
#[cfg(test)]
mod tests {
    use debug::PrintTrait;
    use super::{
        make_block_hash,
        make_seed,
        hash_values,
    };

    #[test]
    fn test_make_block_hash() {
        let h = make_block_hash();
        assert(h != 0, 'block hash');
    }

    #[test]
    fn test_make_seed() {
        let s0 = make_seed(starknet::contract_address_const::<0x0>(), 1);
        let s1 = make_seed(starknet::contract_address_const::<0x1>(), 1);
        let s1_2 = make_seed(starknet::contract_address_const::<0x1>(), 2);
        let s2 = make_seed(starknet::contract_address_const::<0x2>(), 1);
        let s3 = make_seed(starknet::contract_address_const::<0x54f650fb5e1fb61d7b429ae728a365b69e5aff9a559a05de70f606aaea1a243>(), 1);
        let s4 = make_seed(starknet::contract_address_const::<0x19b55e33610cdb4b3ceda054f8870b741733f129992894ebce56f38a4150dfb>(), 1);
        let s0_1 = make_seed(starknet::contract_address_const::<0x0>(), 1);
        // never zero
        assert(s0 != 0,   's0');
        assert(s1 != 0,   's1');
        assert(s1_2 != 0, 's1_2');
        assert(s2 != 0,   's2');
        assert(s3 != 0,   's3');
        assert(s4 != 0,   's4');
        // all different from each other
        assert(s0 != s1,   's0 != s1');
        assert(s1 != s1_2, 's1 != s2');
        assert(s1 != s2,   's1 != s2');
        assert(s2 != s3,   's2 != s3');
        assert(s3 != s4,   's3 != s4');
        // same seed, same value
        assert(s0 == s0_1, 's0 == s0_1');
    }

    #[test]
    fn test_hash_values() {
        let h1: felt252 = hash_values([111].span());
        let h2: felt252 = hash_values([111, 222].span());
        let h22: felt252 = hash_values([222, 111].span());
        let h3: felt252 = hash_values([111, 222, 333].span());
        let h4: felt252 = hash_values([111, 222, 333, 444].span());
        assert(h1 != 0,  'h1');
        assert(h1 != h2, 'h1 != h2');
        assert(h2 != h3, 'h2 != h3');
        assert(h3 != h4, 'h3 != h4');
        assert(h2 != h22, 'h2 != h22');
    }
}
