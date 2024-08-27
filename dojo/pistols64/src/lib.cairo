mod systems {
    mod actions;
}

mod models {
    mod challenge;
    mod round;
}

mod types {
    mod constants;
    mod state;
    mod cards {
        mod paces;
        mod tactics;
        mod blades;
        mod env;
    }
}

mod utils {
    mod store;
    mod seeder;
    mod hash;
    mod random;
    mod math;
}

#[cfg(test)]
mod tests {
    mod tester;
    mod test_challenge;
    mod test_duel;
}
