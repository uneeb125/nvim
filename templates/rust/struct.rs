// Created by {{_author_}} on {{_date_}}
//! {{_file_name_}} - Data structures

/// Example struct
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct {{_camel_file_}} {
    /// Example field
    pub name: String,
    /// Example value
    pub value: i32,
}

impl {{_camel_file_}} {
    /// Create a new instance
    pub fn new(name: impl Into<String>, value: i32) -> Self {
        {{_cursor_}}
        Self {
            name: name.into(),
            value,
        }
    }

    /// Get the name
    pub fn name(&self) -> &str {
        &self.name
    }

    /// Get the value
    pub fn value(&self) -> i32 {
        self.value
    }
}
