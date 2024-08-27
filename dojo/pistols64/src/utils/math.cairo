// use debug::PrintTrait;

trait MathTrait<T,TI> {
    // absolute value
    fn abs(v: TI) -> T;
    // returns minimum value
    fn min(a: T, b: T) -> T;
    // returns maximum value
    fn max(a: T, b: T) -> T;
    // returns a value clamped between min and max
    fn clamp(v: T, min: T, max: T) -> T;
    // safe subtraction
    fn sub(a: T, b: T) -> T;
}

impl MathU8 of MathTrait<u8,i8> {
    fn abs(v: i8) -> u8 {
        if (v < 0) { (-v).try_into().unwrap() } else { (v).try_into().unwrap() }
    }
    fn min(a: u8, b: u8) -> u8 {
        if (a < b) { (a) } else { (b) }
    }
    fn max(a: u8, b: u8) -> u8 {
        if (a > b) { (a) } else { (b) }
    }
    fn clamp(v: u8, min: u8, max: u8) -> u8 {
        if (v < min) { (min) } else if (v > max) { (max) } else { (v) }
    }
    fn sub(a: u8, b: u8) -> u8 {
        if (b >= a) { (0) } else { (a - b) }
    }
}
