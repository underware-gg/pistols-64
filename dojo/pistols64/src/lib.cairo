mod systems {
    mod actions;
}

mod models {
    mod challenge;
    mod round;
}

mod types {
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
}

#[cfg(test)]
mod tests {
    mod tester;
    mod test_challenge;
}
