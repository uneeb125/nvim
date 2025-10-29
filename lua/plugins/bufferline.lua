return {
    {
        "akinsho/bufferline.nvim",
        -- commit = "655133c3b4c3e5e05ec549b9f8cc2894ac6f51b3",
        event = { "BufReadPre", "BufAdd", "BufNew", "BufReadPost" },
        dependencies = {
            -- This plugin provides the `Bdelete` command, which is used below.
            -- lazy.nvim ensures this is loaded before bufferline is configured.
            "famiu/bufdelete.nvim",
            -- commit = "f6bcea78afb3060b198125256f897040538bcb81",
        },
        -- The `opts` table is a direct translation of the arguments
        -- previously passed to `require("bufferline").setup()`.
        opts = {
            options = {
                -- Use Bdelete to close buffers without messing up window layout
                close_command = "Bdelete! %d",
                right_mouse_command = "Bdelete! %d",
                -- Add padding on the left to separate from file explorers like NvimTree
                offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
                separator_style = "thin",
            },
            highlights = {
                fill = {
                    bg = { attribute = "bg", highlight = "TabLine" },
                },
                background = {
                    fg = { attribute = "fg", highlight = "TabLine" },
                    bg = { attribute = "bg", highlight = "TabLine" },
                },
                buffer_visible = {
                    fg = { attribute = "fg", highlight = "TabLine" },
                    bg = { attribute = "bg", highlight = "TabLine" },
                },
                close_button = {
                    fg = { attribute = "fg", highlight = "TabLine" },
                    bg = { attribute = "bg", highlight = "TabLine" },
                },
                close_button_visible = {
                    fg = { attribute = "fg", highlight = "TabLine" },
                    bg = { attribute = "bg", highlight = "TabLine" },
                },
                tab_selected = {
                    fg = { attribute = "fg", highlight = "Normal" },
                    bg = { attribute = "bg", highlight = "Normal" },
                },
                tab = {
                    fg = { attribute = "fg", highlight = "TabLine" },
                    bg = { attribute = "bg", highlight = "TabLine" },
                },
                tab_close = {
                    fg = { attribute = "fg", highlight = "TabLineSel" },
                    bg = { attribute = "bg", highlight = "Normal" },
                },
                duplicate_selected = {
                    fg = { attribute = "fg", highlight = "TabLineSel" },
                    bg = { attribute = "bg", highlight = "TabLineSel" },
                    italic = true,
                },
                duplicate_visible = {
                    fg = { attribute = "fg", highlight = "TabLine" },
                    bg = { attribute = "bg", highlight = "TabLine" },
                    italic = true,
                },
                duplicate = {
                    fg = { attribute = "fg", highlight = "TabLine" },
                    bg = { attribute = "bg", highlight = "TabLine" },
                    italic = true,
                },
                modified = {
                    fg = { attribute = "fg", highlight = "TabLine" },
                    bg = { attribute = "bg", highlight = "TabLine" },
                },
                modified_selected = {
                    fg = { attribute = "fg", highlight = "Normal" },
                    bg = { attribute = "bg", highlight = "Normal" },
                },
                modified_visible = {
                    fg = { attribute = "fg", highlight = "TabLine" },
                    bg = { attribute = "bg", highlight = "TabLine" },
                },
                separator = {
                    fg = { attribute = "bg", highlight = "TabLine" },
                    bg = { attribute = "bg", highlight = "TabLine" },
                },
                separator_selected = {
                    fg = { attribute = "bg", highlight = "Normal" },
                    bg = { attribute = "bg", highlight = "Normal" },
                },
                indicator_selected = {
                    fg = { attribute = "fg", highlight = "LspDiagnosticsDefaultHint" },
                    bg = { attribute = "bg", highlight = "Normal" },
                },
            },
        },
    },
}
