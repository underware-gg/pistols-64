mod models {
    mod planet;
}

mod components {
    mod planetary;
}

mod interfaces {
    mod pistols64;
    mod planetary;
}

mod systems {
    mod actions;
}

mod utils {
    mod misc;
    mod systems;
}


#[cfg(test)]
mod tests {
    mod tester;
    mod test_planetary;
    mod mock_pistols64;
    // component
    mod test_component;
    mod mock_component;
}
