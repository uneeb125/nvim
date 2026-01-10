-- Use Tree-sitter for folding
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- Optional: Start with all folds open
vim.opt_local.foldenable = false -- Type 'zi' to toggle folding
