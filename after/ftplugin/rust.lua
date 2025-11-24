-- Rust-specific keymaps
-- This file is loaded automatically by Neovim for files with the 'rust' filetype.

-- Ensure the leader key is set to space for these keymaps.
vim.g.mapleader = " "

-- Define a helper function for creating buffer-local keymaps.
local map = function(keys, func, desc)
    vim.keymap.set("n", keys, func, { buffer = true, silent = true, desc = "Rust LSP: " .. desc })
end

-- LSP navigation with fzf-lua
map("gd", "<cmd>FzfLua lsp_definitions<CR>", "[G]oto [D]efinition")
map("gr", "<cmd>FzfLua lsp_references<CR>", "[G]oto [R]eferences")
map("gi", "<cmd>FzfLua lsp_implementations<CR>", "[G]oto [I]mplementation")
map("<leader>D", "<cmd>FzfLua lsp_type_definitions<CR>", "Type [D]efinition")
map("<leader>ds", "<cmd>FzfLua lsp_document_symbols<CR>", "[D]ocument [S]ymbols")
map("<leader>ws", "<cmd>FzfLua lsp_workspace_symbols<CR>", "[W]orkspace [S]ymbols")
map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

-- Rustacean.nvim specific keymaps & other actions
map("<leader>ra", function() vim.cmd.RustLsp("codeAction") end, "[R]ust [A]ction")
map("<leader>rr", function() vim.cmd.RustLsp("runnables") end, "[R]ust [R]unnables")
map("<leader>rt", function() vim.cmd.RustLsp("testables") end, "[R]ust [T]estables")
map("<leader>rd", function() vim.cmd.RustLsp("openDocs") end, "[R]ust [D]ocs")
-- map("<leader>rd", function() vim.cmd.RustLsp("debuggables") end, "[R]ust [D]ebuggables")
map("<leader>re", function() vim.cmd.RustLsp("expandMacro") end, "[R]ust [E]xpand Macro")
map("<leader>rc", function() vim.cmd.RustLsp("openCargo") end, "[R]ust [C]argo.toml")
map("<leader>cr", vim.lsp.buf.rename, "[C]ode [R]ename")
map("<leader>rs", vim.lsp.buf.signature_help, "[R]ust [S]ignature Help")

-- Override gk to use rustaceanvim's hover actions, which are more powerful.
map("gk", function() vim.cmd.RustLsp({ "hover", "actions" }) end, "Hover Actions")
