return {
    "saghen/blink.cmp",

    -- This is the most important line.
    -- It tells lazy.nvim to not load this plugin (and its dependencies)
    -- until you enter insert mode for the first time.
    event = "InsertEnter",

    -- Pinning to a major version is a good way to ensure stability.
    version = "1.*",

    -- All related plugins are now listed as dependencies.
    -- This ensures they are installed and loaded together.
    dependencies = {
        "saghen/blink.compat",
        "rafamadriz/friendly-snippets",
        "moyiz/blink-emoji.nvim",
        "ray-x/cmp-sql",
    },

    -- The configuration for blink.cmp goes directly in the `opts` table.
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
    keymap = {
            preset = "default",
            ["<Tab>"] = { "accept", "fallback" },
            ["<C-space>"] = {},
            ["<C-s>"] = { "show", "show_signature", "hide_signature" },
            ["<C-k>"] = { "show", "show_documentation", "hide_documentation" },
            ["<C-e>"] = { "hide", "show" },
        },
        appearance = {
            nerd_font_variant = "mono",
        },

        completion = { 
            documentation = { auto_show = true },
            ghost_text = { enabled = false }
        },
        signature = { enabled = true },

        sources = {
            default = { "lsp", "path", "snippets", "buffer", "emoji", "sql" },
            providers = {
                emoji = {
                    module = "blink-emoji",
                    name = "Emoji",
                    score_offset = 15,
                    opts = { insert = true },
                    should_show_items = function()
                        return vim.tbl_contains({ "gitcommit", "markdown" }, vim.o.filetype)
                    end,
                },
                sql = {
                    name = "sql",
                    module = "blink.compat.source",
                    score_offset = -3,
                    opts = {},
                    should_show_items = function()
                        return vim.tbl_contains({ "sql" }, vim.o.filetype)
                    end,
                },
            },
        },

        fuzzy = { implementation = "prefer_rust_with_warning" },
    },

    -- The config function is a great place for setup that needs to run
    -- after the plugin and its dependencies are loaded. Here, we set up
    -- the compatibility layer.
    config = function(_, opts)
        -- Set up the main blink.cmp plugin with the options from `opts`.
        require("blink.cmp").setup(opts)

        -- Set up the compatibility layer.
        -- This ensures that nvim-cmp sources (like cmp-sql) work correctly.
        require("blink.compat").setup()
    end,
}
