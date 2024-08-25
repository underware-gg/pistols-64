mod components {
    mod planetary;
}

mod interfaces {
    // public planetary interface
    mod planetary;
    // public planets
    mod pistols64;
    mod vulcan; // test planet
}

mod utils {
    mod misc;
    mod systems;
}

#[cfg(test)]
mod tests {
    mod test_component;
    mod mock_component;
}
