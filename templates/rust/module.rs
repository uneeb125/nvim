// Created by {{_author_}} on {{_date_}}
//! {{_file_name_}} module

/// Example struct
#[derive(Debug, Clone)]
pub struct {{_camel_file_}} {
    /// Example field
    pub value: i32,
}

impl {{_camel_file_}} {
    /// Create a new instance
    pub fn new(value: i32) -> Self {
        {{_cursor_}}
        Self { value }
    }
}

impl Default for {{_camel_file_}} {
    fn default() -> Self {
        Self::new(0)
    }
}
