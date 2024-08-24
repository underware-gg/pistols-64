mod components {
    mod planetary;
}

mod interfaces {
    mod pistols64;
    mod planetary;
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
