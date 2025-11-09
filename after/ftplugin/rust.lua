-- Rust-specific keymaps
-- This file is loaded automatically by Neovim for files with the 'rust' filetype.

-- Ensure the leader key is set to space for these keymaps.
vim.g.mapleader = " "

local keymap = vim.keymap.set
local opts = { silent = true, buffer = true }

-- Rustacean.nvim specific keymaps
keymap("n", "<leader>ra", function()
    vim.cmd.RustLsp("codeAction")
end, { desc = "Rust Code Action", buffer = true, silent = true })
keymap("n", "<leader>rr", function()
    vim.cmd.RustLsp("runnables")
end, { desc = "Rust Runnables", buffer = true, silent = true })
keymap("n", "<leader>rt", function()
    vim.cmd.RustLsp("testables")
end, { desc = "Rust Testables", buffer = true, silent = true })
keymap("n", "<leader>rd", function()
    vim.cmd.RustLsp("debuggables")
end, { desc = "Rust Debuggables", buffer = true, silent = true })
keymap("n", "<leader>re", function()
    vim.cmd.RustLsp("expandMacro")
end, { desc = "Rust Expand Macro", buffer = true, silent = true })
keymap("n", "<leader>rc", function()
    vim.cmd.RustLsp("openCargo")
end, { desc = "Rust Open Cargo.toml", buffer = true, silent = true })
keymap("n", "<leader>rn", function()
    vim.lsp.buf.rename()
end, { desc = "Rust Rename", buffer = true, silent = true })

-- Override K to use rustaceanvim's hover actions, which are more powerful.
keymap("n", "gk", function()
    vim.cmd.RustLsp({ "hover", "actions" })
end, { desc = "Rust Hover Actions", buffer = true, silent = true })

-- Standard LSP keymaps for Rust files
keymap("n", "gd", function()
    vim.lsp.buf.definition()
end, { desc = "Go to Definition", buffer = true, silent = true })
keymap("n", "gr", function()
    vim.lsp.buf.references()
end, { desc = "Go to References", buffer = true, silent = true })
keymap("n", "gD", function()
    vim.lsp.buf.declaration()
end, { desc = "Go to Declaration", buffer = true, silent = true })
keymap("n", "gi", function()
    vim.lsp.buf.implementation()
end, { desc = "Go to Implementation", buffer = true, silent = true })
keymap("n", "<leader>rs", function()
    vim.lsp.buf.signature_help()
end, { desc = "Rust Signature Help", buffer = true, silent = true })

-- You can add more keymaps here as you discover more features you use often.
