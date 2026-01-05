// Created by {{_author_}} on {{_date_}}
//! {{_file_name_}} - Rust library

/// Example function
///
/// # Examples
///
/// ```
/// let result = example();
/// ```
pub fn example() -> i32 {
    {{_cursor_}}
    42
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_example() {
        assert_eq!(example(), 42);
    }
}
