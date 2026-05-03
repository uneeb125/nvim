return {
    "catppuccin/nvim",
    commit = "fa42eb5e26819ef58884257d5ae95dd0552b9a66",
    name = "catppuccin",
    priority = 1000,
    config = function()
        -- 1. Enable True Color BEFORE loading the theme
        vim.opt.termguicolors = true

        -- 2. Setup the theme
        require("catppuccin").setup({
            flavour = "mocha",
            background = {
                light = "latte",
                dark = "mocha",
            },
            -- If you want Neovim to be transparent and show your terminal wallpaper, leave this true.
            -- If you want the standard Catppuccin Mocha background (#1e1e2e), change this to false.
            transparent_background = true, 
            show_end_of_buffer = false,
            term_colors = true,
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
            custom_highlights = function(colors)
                return {
                    -- Make floating windows and popups lighter than the pure black background
                    NormalFloat = { bg = colors.base },
                    FloatBorder = { bg = colors.base, fg = colors.surface2 },
                    FloatTitle = { bg = colors.base, fg = colors.lavender, bold = true },
                    FloatFooter = { bg = colors.base, fg = colors.overlay0 },
                    -- Completion menu
                    Pmenu = { bg = colors.base },
                    PmenuSel = { bg = colors.surface1 },
                    PmenuSbar = { bg = colors.base },
                    PmenuThumb = { bg = colors.surface2 },
                }
            end,
            default_integrations = true,
            integrations = {
                cmp = true,
                gitsigns = true,
                illuminate = { enabled = true, lsp = true },
                indent_blankline = {
                    enabled = true,
                    scope_color = "lavender",
                    colored_indent_levels = true,
                },
                mini = { enabled = true },
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
                    inlay_hints = { background = true },
                },
                nvimtree = true,
                rainbow_delimiters = true,
                telescope = { enabled = true },
                treesitter = true,
            },
        })

        vim.opt.termguicolors = true
        vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
        vim.api.nvim_set_hl(0, "NormalNC", { bg = "#000000" })

        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "*",
            callback = function()
                vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
                vim.api.nvim_set_hl(0, "NormalNC", { bg = "#000000" })
            end,
        })
        
        -- 3. Load the colorscheme
        vim.cmd.colorscheme("catppuccin")
        
        -- (Removed the pure black background overrides so standard Mocha or transparency can work)
    end,
}
