-- return {
--     "rebelot/kanagawa.nvim",
--     branch = "master",
--     config = function()
--         require("kanagawa").setup({
--             transparent = true,
--             overrides = function(colors)
--                 return {
--                     ["@markup.link.url.markdown_inline"] = { link = "Special" }, -- (url)
--                     ["@markup.link.label.markdown_inline"] = { link = "WarningMsg" }, -- [label]
--                     ["@markup.italic.markdown_inline"] = { link = "Exception" }, -- *italic*
--                     ["@markup.raw.markdown_inline"] = { link = "String" }, -- `code`
--                     ["@markup.list.markdown"] = { link = "Function" }, -- + list
--                     ["@markup.quote.markdown"] = { link = "Error" }, -- > blockcode
--                     ["@markup.list.checked.markdown"] = { link = "WarningMsg" }, -- - [X] checked list item
--                 }
--             end,
--         })
--         vim.cmd("colorscheme kanagawa")
--     end,
-- }

-- This is the idiomatic lazy.nvim structure for a plugin spec.
return {
    "catppuccin/nvim",

    -- Pinning to a specific commit is good practice for stability.
    commit = "fa42eb5e26819ef58884257d5ae95dd0552b9a66",

    -- The `name` is important for other plugins to refer to, and for `vim.cmd.colorscheme`.
    name = "catppuccin",

    -- A high priority ensures it loads before other plugins that depend on it for colors.
    priority = 1000,

    -- The config function is where the setup and loading happens.
    config = function()
        -- IMPORTANT: The setup function must be called BEFORE setting the colorscheme.
        -- `setup()` compiles the theme, making it very fast to load.
        require("catppuccin").setup({
            flavour = "mocha",
            background = {
                light = "latte",
                dark = "mocha",
            },
            transparent_background = false,
            show_end_of_buffer = false,
            term_colors = false,
            dim_inactive = {
                enabled = false,
                shade = "dark",
                percentage = 0.15,
            },
            no_italic = false,
            no_bold = false,
            no_underline = false,
            styles = {
                comments = { "italic" },
                conditionals = { "italic" },
                loops = {},
                functions = {},
                keywords = {},
                strings = {},
                variables = {},
                numbers = {},
                booleans = {},
                properties = {},
                types = {},
                operators = {},
            },
            color_overrides = {},
            custom_highlights = {},

            -- Best Practice: Set default_integrations to false and explicitly enable only
            -- the ones you use. This prevents loading code for plugins you don't have.
            default_integrations = true,
            integrations = {
                cmp = true,
                gitsigns = true,
                illuminate = {
                    enabled = true,
                    lsp = true,
                },
                indent_blankline = {
                    enabled = true,
                    scope_color = "lavender",
                    colored_indent_levels = true,
                },
                mini = {
                    enabled = true,
                },
                native_lsp = {
                    enabled = true,
                    virtual_text = {
                        errors = { "italic" },
                        hints = { "italic" },
                        warnings = { "italic" },
                        information = { "italic" },
                        ok = { "italic" },
                    },
                    underlines = {
                        errors = { "underline" },
                        hints = { "underline" },
                        warnings = { "underline" },
                        information = { "underline" },
                        ok = { "underline" },
                    },
                    inlay_hints = {
                        background = true,
                    },
                },
                nvimtree = true,
                rainbow_delimiters = true,
                telescope = {
                    enabled = true,
                },
                treesitter = true,
            },
        })

        -- This command now uses the compiled Lua theme, which is extremely fast.
        vim.cmd.colorscheme("catppuccin")
    end,
}

--
--

-- return {
--     {
--         "EdenEast/nightfox.nvim",
--         -- To ensure the colorscheme is loaded first, we can use `priority`
--         -- or `lazy = false`. `priority` is recommended for themes.
--         priority = 1000,
--         -- The `config` function is the ideal place to configure and then load the colorscheme
--         -- because it guarantees that `setup()` is called before `colorscheme`.
--         config = function()
--             -- You can configure the theme here, or leave it empty to use the defaults.
--             -- This is the equivalent of `require('nightfox').setup({ ... })`
--             require("nightfox").setup({
--                 options = {
--                     -- Your custom options go here
--                     -- For example, to make comments italic and keywords bold:
--                     styles = {
--                         comments = "italic",
--                         keywords = "bold",
--                         types = "italic,bold",
--                     },
--                     -- Enable transparent background
--                     transparent = false,
--                     -- Dim inactive windows
--                     dim_inactive = true,
--                 },
--                 -- You can also override palettes, specs, and groups here
--                 -- palettes = {},
--                 -- specs = {},
--                 -- groups = {},
--             })
--
--             -- Load the colorscheme
--             -- You can change "nightfox" to "dayfox", "dawnfox", "duskfox", "nordfox", etc.
--             vim.cmd.colorscheme("nightfox")
--         end,
--     },
-- }
