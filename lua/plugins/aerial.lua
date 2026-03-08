return {
    "stevearc/aerial.nvim",
    opts = {
        -- 1. PRIORITY: Must be Treesitter. 
        -- LSP servers (like pyright/lua_ls) explicitly ignore if/else statements.
        backends = { "treesitter", "lsp", "markdown", "man" },

        layout = {
            -- "edge" forces it to behave like a sidebar (vs "window" which splits relatively)
            placement = "edge",
            -- Puts the sidebar on the right
            default_direction = "prefer_right",
        },

        -- 2. FILTER: Set to false to show absolutely EVERYTHING the parser finds.
        -- By default, Aerial hides "noisy" items. We need this off to see control flow.
        filter_kind = false,

        -- 3. VISUALS
        show_guides = true, -- Show indentation lines (useful for if/else nesting)
        icons = {
            -- You can customize icons here if 'If' statements show up with weird icons
            -- Because 'ControlFlow' isn't a standard SymbolKind, they might default to something else.
        },
    },
    -- Optional dependencies
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
    },
    keys = {
        -- Map Toggle to Leader + Capital A
        { "<leader>L", "<cmd>AerialToggle!<CR>", desc = "Toggle Aerial" },
    },
}
