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
        "micangl/cmp-vimtex",
        "ribru17/blink-cmp-spell",
    },

    -- The configuration for blink.cmp goes directly in the `opts` table.
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
    keymap = {
            preset = "default",
            ["<Tab>"] = { "accept", "fallback" },
            ["<C-space>"] = {},
            ["<C-l>"] = { "show", "show_signature", "hide_signature" },
            ["<C-k>"] = { "show", "show_documentation", "hide_documentation" },
            ["<C-e>"] = { "hide", "show" },
        },
        appearance = {
            nerd_font_variant = "mono",
        },

        completion = {
            documentation = {
                auto_show = true,
                window = {
                    border = 'rounded',
                    direction_priority = {
                        menu_north = { 'e', 'n', 's' },
                        menu_south = { 'e', 's', 'n' },
                    },
                },
            },
            ghost_text = { enabled = false },
            menu = {
                border = 'rounded',
                auto_show_delay_ms = 0,
                draw = {
                    treesitter = { 'lsp' },
                    columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 }, { 'source_name' } },
                    components = {
                        kind_icon = {
                            text = function(ctx)
                                local icon, _ = require('mini.icons').get('lsp', ctx.kind)
                                return (icon or ctx.kind_icon) .. ctx.icon_gap
                            end,
                            highlight = function(ctx)
                                local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                                return hl or ctx.kind_hl
                            end,
                        },
                    },
                },
            },
            keyword = { range = "full" },
            trigger = {
                show_on_trigger_character = true,
                show_on_keyword = true,
                show_on_insert_on_trigger_character = true,
            },
        },
        signature = { enabled = true, window = { border = 'rounded' } },

        sources = {
            default = { "lsp", "path", "snippets", "buffer", "emoji", "spell" },

            per_filetype = {
                sql = { inherit_defaults = true, "sql" },
                tex = { inherit_defaults = true, "vimtex" },
                plaintex = { inherit_defaults = true, "vimtex" },
            },
            providers = {
                path = {
                    name = "Path",
                    module = "blink.cmp.sources.path",
                    score_offset = 3,
                    opts = {
                        trailing_slash = false,
                        label_trailing_slash = true,
                        get_cwd = function(context)
                            local bufpath = vim.api.nvim_buf_get_name(context.bufnr)
                            local startpath = bufpath ~= "" and vim.fn.fnamemodify(bufpath, ":p:h") or vim.fn.getcwd()

                            -- Use vim.fs.root if available (Neovim 0.10+)
                            if vim.fs and vim.fs.root then
                                local root = vim.fs.root(startpath, { ".git", ".jj", "package.json", "Cargo.toml", "pyproject.toml" })
                                if root then
                                    return root
                                end
                            end

                            -- Fallback for older Neovim versions
                            local markers = { ".git", ".jj", "package.json", "Cargo.toml", "pyproject.toml" }
                            for _, marker in ipairs(markers) do
                                local found = vim.fs.find(marker, { path = startpath, upward = true, stop = vim.loop.os_homedir() })
                                if found and #found > 0 then
                                    return vim.fn.fnamemodify(found[1], ":h")
                                end
                            end

                            return startpath
                        end,
                        show_hidden_files_by_default = true,
                    },
                },
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
                spell = {
                    name = "Spell",
                    module = "blink-cmp-spell",
                    score_offset = -3,
                },
                snippets = {
                    module = "blink.cmp.sources.snippets",
                    score_offset = -2,
                    opts = {
                        use_show_condition = true,
                        show_autosnippets = true,
                        use_label_description = true,
                    },
                },
                vimtex = {
                    name = "vimtex",
                    module = "blink.compat.source",
                    score_offset = 5,
                    opts = {},
                    should_show_items = function()
                        return vim.tbl_contains({ "tex", "plaintex" }, vim.o.filetype)
                    end,
                },
            },
        },

        snippets = { preset = "luasnip", score_offset = 0 },
        fuzzy = {
            implementation = "prefer_rust_with_warning",
            sorts = { 'exact', 'score', 'sort_text' },
        },

        cmdline = {
            keymap = { preset = "cmdline" },
            completion = {
                menu = { auto_show = true },
            },
        },
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
