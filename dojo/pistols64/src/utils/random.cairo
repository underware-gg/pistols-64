
// https://github.com/starkware-libs/cairo/blob/main/corelib/src/pedersen.cairo
extern fn pedersen(a: felt252, b: felt252) -> felt252 implicits(Pedersen) nopanic;

fn throw_dice(ref seed: felt252, faces: u8) -> u8 {
    seed = pedersen(seed, seed);
    let double: u256 = seed.into();
    let dice: u8 = ((double.low % faces.into()) + 1).try_into().unwrap();
    (dice)
}

