-- -----------------------------------------------------------------------------
-- GENERAL BEHAVIOR
-- -----------------------------------------------------------------------------
vim.opt.shada = { "!", "'1000", "<50", "s10", "h", "f1000" }
vim.opt.clipboard = "unnamedplus"
local has_display = vim.env.DISPLAY or vim.env.WAYLAND_DISPLAY
local function local_copy(selection, lines)
    if not has_display then return end
    local data = table.concat(lines, "\n")
    local cmd
    if vim.env.WAYLAND_DISPLAY then
        cmd = selection == "+" and "wl-copy" or "wl-copy --primary"
    else
        cmd = selection == "+" and "xclip -selection clipboard" or "xclip -selection primary"
    end
    local proc = io.popen(cmd, "w")
    if proc then proc:write(data); proc:close() end
end

local function local_paste(selection)
    if not has_display then return nil end
    local cmd
    if vim.env.WAYLAND_DISPLAY then
        cmd = selection == "+" and "wl-paste --no-newline" or "wl-paste --no-newline --primary"
    else
        cmd = selection == "+" and "xclip -selection clipboard -o" or "xclip -selection primary -o"
    end
    local proc = io.popen(cmd, "r")
    if not proc then return nil end
    local output = proc:read("*a")
    proc:close()
    if output and output ~= "" then
        return vim.split(output, "\n")
    end
    return nil
end

vim.g.clipboard = {
    name = "multi",
    copy = {
        ["+"] = function(lines)
            require("vim.ui.clipboard.osc52").copy("+")(lines)
            local_copy("+", lines)
        end,
        ["*"] = function(lines)
            require("vim.ui.clipboard.osc52").copy("*")(lines)
            local_copy("*", lines)
        end,
    },
    paste = {
        ["+"] = function()
            return local_paste("+") or require("vim.ui.clipboard.osc52").paste("+")()
        end,
        ["*"] = function()
            return local_paste("*") or require("vim.ui.clipboard.osc52").paste("*")()
        end,
    },
}
vim.opt.mouse = "a" -- Enable mouse support in all modes
vim.opt.timeoutlen = 100 -- Time in ms to wait for a mapped sequence
vim.opt.updatetime = 300 -- Faster completion (default is 4000ms)
vim.opt.completeopt = { "menuone", "noselect" } -- Set completion options, mainly for nvim-cmp
vim.opt.iskeyword:append("-", '"') -- Treat these characters as part of a word

-- Disable built-in snippet parser to use LuaSnip
vim.g.loaded_snippets = 1

-- Enable autoread
vim.o.autoread = true

-- Automatically check for file changes on focus or buffer enter
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
    command = "if mode() != 'c' | checktime | endif",
    pattern = "*",
})

-- Periodically check for file changes (every 2 seconds)
local checktime_interval_ms = 1000
vim.fn.timer_start(checktime_interval_ms, function()
    if vim.fn.mode() ~= "c" then
        vim.cmd("checktime")
    end
end, { ["repeat"] = -1 })

-- -----------------------------------------------------------------------------
-- UI & APPEARANCE
-- -----------------------------------------------------------------------------
vim.g.snacks_animate = true
vim.opt.termguicolors = true -- Enable 24-bit RGB colors
vim.opt.cmdheight = 1 -- More space for messages
vim.opt.pumheight = 10 -- Pop-up menu height
vim.opt.showtabline = 0 -- Always hide the tabline
vim.opt.laststatus = 3 -- Always display the status line
vim.opt.showcmd = true -- Show the command in the last line
vim.opt.ruler = false -- Don't show the ruler
vim.opt.guifont = "monospace:h17" -- Font for graphical Neovim

-- Line Numbers
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = false -- Show relative line numbers
vim.opt.numberwidth = 4 -- Width of the number column
vim.opt.signcolumn = "yes" -- Always show the sign column

-- Highlighting & Display
vim.opt.cursorline = true -- Highlight the current line
vim.opt.conceallevel = 0 -- Don't conceal text (e.g., show `` in markdown)
vim.opt.fillchars.eob = " " -- Hide the `~` at the end of the buffer
vim.opt.list = true -- Show invisible characters
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- -----------------------------------------------------------------------------
-- TEXT EDITING & INDENTATION
-- -----------------------------------------------------------------------------
vim.opt.textwidth = 80
vim.opt.colorcolumn = "80"
vim.opt.cursorcolumn = true

-- vim.opt.formatoptions:append("t")

-- Use spaces instead of tabs
vim.opt.expandtab = true
vim.opt.tabstop = 4 -- Number of spaces a <Tab> in the file counts for
vim.opt.shiftwidth = 4 -- Number of spaces to use for autoindent
vim.opt.softtabstop = 4 -- Number of spaces <Tab> inserts
vim.opt.foldcolumn = 'auto:1'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.foldopen:remove("hor")

-- Smart indentation
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Wrapping
vim.opt.wrap = true -- Wrap long lines
vim.opt.linebreak = true -- Wrap lines at convenient places (word boundaries)
vim.opt.breakindent = true -- Preserve indentation on wrapped lines
vim.opt.whichwrap:append("<,>,[,],h,l") -- Allow specified keys to wrap
vim.opt.scrolloff = 8 -- Keep 8 lines visible above/below the cursor
vim.opt.sidescrolloff = 8 -- Keep 8 columns visible to the left/right

-- -----------------------------------------------------------------------------
-- SEARCHING
-- -----------------------------------------------------------------------------
vim.opt.hlsearch = true -- Highlight all matches on search
vim.opt.ignorecase = true -- Ignore case in search patterns
vim.opt.smartcase = true -- Override ignorecase if the search pattern has uppercase letters

-- -----------------------------------------------------------------------------
-- FILE HANDLING & BACKUPS
-- -----------------------------------------------------------------------------
vim.opt.backup = false -- Do not create a backup file
vim.opt.swapfile = false -- Do not create a swapfile
vim.opt.writebackup = false -- Do not create a write backup
vim.opt.undofile = true -- Enable persistent undo
vim.opt.fileencoding = "utf-8" -- The encoding written to a file
vim.opt.shortmess:append("c") -- Don't pass messages to |ins-completion-menu|

-- -----------------------------------------------------------------------------
-- WINDOW & SPLIT MANAGEMENT
-- -----------------------------------------------------------------------------
vim.opt.splitbelow = true -- Force horizontal splits to go below
vim.opt.splitright = true -- Force vertical splits to go to the right

-- -----------------------------------------------------------------------------
-- VSCODE SPECIFIC OVERRIDES
-- -----------------------------------------------------------------------------
if vim.g.vscode then
    -- When using the Neovim extension in VSCode, we need to see modes like -- INSERT --
    vim.opt.showmode = true
else
    -- In standalone Neovim, the statusline shows the mode, so this is redundant
    vim.opt.showmode = false
end

-- Set default for format on save to be off
vim.g.autoformat_on_save = false
