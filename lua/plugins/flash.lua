return {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
        highlight = {
            backdrop = true,
            groups = {
                match = "FlashMatch",
                current = "FlashCurrent",
                backdrop = "FlashBackdrop",
                label = "FlashLabel",
            },
        },
        search = {
            wrap = true,
            mode = "exact",
            exclude = {
                "notify",
                "cmp_menu",
                "noice",
                "flash_prompt",
                function(win)
                    return not vim.api.nvim_win_get_config(win).focusable
                end,
            },
        },
        label = {
            uppercase = true,
            current = true,
            after = true,
            style = "overlay",
            reuse = "lowercase",
            rainbow = {
                enabled = true,
                shade = 5,
            },
        },
        modes = {
            char = {
                enabled = true,
                autohide = true,
                jump_labels = true,
                multi_line = true,
                autojump = true,
                label = { exclude = "hjkliardc" },
            },
            search = {
                enabled = false,
                highlight = { backdrop = false },
                jump = {
                    history = true,
                    register = true,
                    nohlsearch = true,
                    autojump = true,
                },
                search = {
                    mode = "search",
                    incremental = true,
                },
            },
            treesitter = {
                labels = "abcdefghijklmnopqrstuvwxyz",
                jump = { pos = "range", autojump = true },
                label = { before = true, after = true, style = "inline" },
            },
        },
    },
    -- stylua: ignore
    keys = {
        { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
        { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
        { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
        { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
        { "f", mode = { "n", "x", "o" }, function() require("flash").jump({ mode = "char" }) end, desc = "Flash Char" },
    },
}
