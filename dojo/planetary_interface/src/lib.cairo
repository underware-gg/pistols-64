mod interfaces {
    // public planetary interface
    mod planetary;
    // public planets
    mod pistols64;
    mod vulcan; // test planet
    mod tot;
}

mod systems {
    mod vulcan;
}

mod utils {
    mod misc;
    mod systems;
}

mod components {
    mod planetary;
}

#[cfg(test)]
mod tests {
    mod test_component;
    mod mock_component;
}
