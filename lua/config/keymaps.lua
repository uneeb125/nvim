vim.keymap.set("n", "-", "<cmd>Oil --float<CR>", { desc = "Open Parent Directory in Oil" })
vim.keymap.set("n", "gl", function()
    vim.diagnostic.open_float()
end, { desc = "Open Diagnostics in Float" })

vim.keymap.set("n", "<leader>cf", function()
    require("conform").format({
        lsp_format = "fallback",
    })
end, { desc = "Format current file" })

vim.keymap.set("n", "<leader>ct", function()
    if vim.g.autoformat_on_save == nil then
        vim.g.autoformat_on_save = false
    end
    vim.g.autoformat_on_save = not vim.g.autoformat_on_save
    if vim.g.autoformat_on_save then
        print("Format on save enabled")
    else
        print("Format on save disabled")
    end
end, { desc = "Toggle Format on Save" })

-- Map <leader>fp to open projects
vim.keymap.set("n", "<leader>fp", ":ProjectFzf<CR>", { noremap = true, silent = true })

-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

--Remap space as leader key
-- keymap("", "<Space>", "<Nop>", opts)
-- vim.g.mapleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- keymap("n", "F", ":HopLineStartMW<CR>", opts)
-- keymap("n", "fw", ":HopWordMW<CR>", opts)
-- keymap("n", "fp", ":HopPatternMW<CR>", opts)
-- keymap("n", "fc", ":HopChar2MW<CR>", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers

keymap("n", "<S-h>", ":bprevious<CR>", opts)
keymap("n", "<S-l>", ":bnext<CR>", opts)

-- Clear highlights
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", opts)

-- Close buffers
keymap("n", "<S-q>", "<cmd>Bdelete!<CR>", opts)

-- Select all
keymap("n", "<C-a>", "ggVG", opts)
keymap("i", "<C-a>", "ggVG", opts)
keymap("v", "<C-a>", "ggVG", opts)

-- Save
keymap("n", "<C-s>", "<cmd>w<CR>", opts)
keymap("i", "<C-s>", "<cmd>w<CR>", opts)
keymap("v", "<C-s>", "<cmd>w<CR>", opts)

-- Quit Nvim
keymap("n", "<C-c>", "<cmd>q!<CR>", opts)
keymap("i", "<C-c>", "<cmd>q!<CR>", opts)
keymap("v", "<C-c>", "<cmd>q!<CR>", opts)

-- Better paste
keymap("v", "p", "P", opts)

-- Wrap nav
-- keymap("n", "j", "gj", opts)
-- keymap("n", "k", "gk", opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)
keymap("i", "kj", "<ESC>", opts)
keymap("v", "u", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Hard wrap visually selected text
keymap("v", "<leader>wq", "gq", { desc = "Hard wrap selected text" })
-- Join visually selected lines
keymap("v", "<leader>wj", "J", { desc = "Join selected lines" })
-- Rewrap hardwarp
keymap("v", "<leader>wt", "JVgq", { desc = "Toggle wrap selected lines" })

-- Plugins --

-- NvimTree
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)

-- -- Telescope
-- keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
-- keymap("n", "<leader>ft", ":Telescope live_grep<CR>", opts)
-- keymap("n", "<leader>fp", ":Telescope projects<CR>", opts)
-- keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)

-- Git
keymap("n", "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", opts)

-- Comment
keymap("n", "<leader>/", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", opts)
keymap("x", "<leader>/", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", opts)

-- -- DAP
-- keymap("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", opts)
-- keymap("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", opts)
-- keymap("n", "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", opts)
-- keymap("n", "<leader>do", "<cmd>lua require'dap'.step_over()<cr>", opts)
-- keymap("n", "<leader>dO", "<cmd>lua require'dap'.step_out()<cr>", opts)
-- keymap("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", opts)
-- keymap("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", opts)
-- keymap("n", "<leader>du", "<cmd>lua require'dapui'.toggle()<cr>", opts)
-- keymap("n", "<leader>dt", "<cmd>lua require'dap'.terminate()<cr>", opts)

-- Lsp
keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", opts)
keymap("n", "gd", "<cmd>FzfLua lsp_definitions<CR>", { desc = "LSP: Go to Definition" })
keymap("n", "gr", "<cmd>FzfLua lsp_references<CR>", { desc = "LSP: Go to References" })
keymap("n", "gI", "<cmd>FzfLua lsp_implementations<CR>", { desc = "LSP: Go to Implementation" })
keymap("n", "<leader>ld", "<cmd>FzfLua lsp_type_definitions<CR>", { desc = "LSP: Type Definition" })
keymap("n", "<leader>ds", "<cmd>FzfLua lsp_document_symbols<CR>", { desc = "LSP: Document Symbols" })
keymap("n", "<leader>ws", "<cmd>FzfLua lsp_workspace_symbols<CR>", { desc = "LSP: Workspace Symbols" })
-- keymap("n", "<leader>ca", function()
--     vim.lsp.buf.code_action({ apply = true })
-- end, { desc = "LSP: Apply First Code Action" })


keymap("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: Code Action Menu" })

keymap("n", "<leader>cr", vim.lsp.buf.rename, { desc = "LSP: Code Rename" })
keymap("n", "<leader>di", "<cmd>:lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<CR>", { desc = "LSP: Show inlay" })
keymap("n", "gD", vim.lsp.buf.declaration, { desc = "LSP: Go to Declaration" })
keymap("n", "go", vim.lsp.buf.hover, { desc = "LSP: Hover Documentation" })

-- LSP Diagnostics
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
-- fzf-lua diagnostics
keymap("n", "<leader>Dl", "<cmd>FzfLua diagnostics_document<CR>", { desc = "List buffer diagnostics (Fzf)" })
keymap("n", "<leader>Dw", "<cmd>FzfLua diagnostics_workspace<CR>", { desc = "List workspace diagnostics (Fzf)" })
-- quickfix diagnostics
keymap("n", "<leader>dl", function() vim.diagnostic.setqflist({ bufnr = 0 }) vim.cmd("copen") end, { desc = "List buffer diagnostics (Quickfix)" })
keymap("n", "<leader>dw", function() vim.diagnostic.setqflist() vim.cmd("copen") end, { desc = "List workspace diagnostics (Quickfix)" })


-- vim.keymap.set("n", "<leader>di", function()
--     if vim.lsp.inlay_hint.enable == nil then
--         vim.lsp.inlay_hint.enable = false
--     end
--     vim.lsp.inlay_hint.enable = not vim.lsp.inlay_hint.enable
-- end, { desc = "Toggle Diagnostic Virtual Text" })

vim.keymap.set("n", "<leader>dv", function()
    if vim.g.diagnostics_virtual_text_enabled == nil then
        vim.g.diagnostics_virtual_text_enabled = false
    end
    vim.g.diagnostics_virtual_text_enabled = not vim.g.diagnostics_virtual_text_enabled
    vim.diagnostic.config({ virtual_text = vim.g.diagnostics_virtual_text_enabled })
end, { desc = "Toggle Diagnostic Virtual Text" })


-- Move like sonic
keymap("n", "<S-j>", "5j", opts)
keymap("n", "<S-k>", "5k", opts)
keymap("v", "<S-j>", "5j", opts)
keymap("v", "<S-k>", "5k", opts)

-- Move in insert mode
keymap("i", "<A-j>", "<ESC>ji", opts)
keymap("i", "<A-k>", "<ESC>ki", opts)
keymap("i", "<A-h>", "<ESC>hi", opts)
keymap("i", "<A-l>", "<ESC>li", opts)

-- Multicursor
keymap("n", "<A-m>", "<C-n>", opts)
keymap("n", "<A-n>", "q", opts)
