-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Set leader keys BEFORE loading lazy.nvim
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Load general editor options
require("config.options")

-- Setup lazy.nvim with performance optimizations
require("lazy").setup({
    spec = {
        { import = "plugins" },
    },

    -- === PERFORMANCE OPTIONS ===

    -- 1. The Loader Cache (the most important optimization)
    --    This caches the file system paths for your plugins, so that `require()`
    --    can be fast-tracked. This is the single biggest speedup for lazy.nvim.
    dev = {
        path = vim.fn.stdpath("cache") .. "/lazy",
        fallback = true, -- Fallback to git when there are git errors
    },

    -- 2. Performance tuning for the runtime path (rtp)
    performance = {
        rtp = {
            -- This will disable adding all plugins to the runtimepath.
            -- Instead, lazy.nvim will add a plugin to the rtp when it is loaded.
            -- This is a major performance boost, as it reduces the number of paths
            -- Neovim has to search when looking for files.
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },

    -- 3. Disable the update checker (optional, but saves a background process)
    --    You can still check for updates manually with `:Lazy`
    checker = {
        enabled = false,
        notify = false,
    },

    -- 4. Change detection can be expensive, but is useful for development.
    --    For daily use, you can disable it.
    change_detection = {
        enabled = false,
        notify = false,
    },

    -- === OTHER OPTIONS ===
    install = {
        colorscheme = { "catppuccin", "kanagawa" }, -- Use your theme during install
    },
})

-- Load your custom keymaps AFTER lazy.nvim is setup
-- This is crucial so that lazy.nvim can use your keymaps as triggers
require("config.keymaps")
