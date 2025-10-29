return {
    "akinsho/toggleterm.nvim",
    version = "*", -- Follow the latest stable release
    opts = {
        -- You can change the size of the terminal window.
        -- This can be a number (columns) or a function that returns a number.
        size = 20,

        -- The mapping to open and close the terminal.
        open_mapping = [[<c-\>]],

        -- By default, pressing the open_mapping in a terminal window will close it.
        -- This keeps the terminal window open unless you explicitly close it.
        hide_numbers = true, -- Hide the number column in toggleterm buffers

        -- When true, the terminal will be shaded to be darker than other windows.
        shade_terminals = true,

        -- The shading factor, a number from 1 to 100.
        shading_factor = 2,

        -- Start the terminal in insert mode.
        start_in_insert = true,

        -- Remember the last opened terminal.
        persist_size = true,

        -- The direction to open the terminal.
        -- Can be 'vertical', 'horizontal', 'tab', or 'float'.
        direction = "float",

        -- Close the terminal window when the process exits.
        close_on_exit = true,

        -- These are settings specific to floating terminals.
        float_opts = {
            -- You can define a border for the floating terminal.
            border = "curved", -- Options: 'single', 'double', 'shadow', 'curved'
            winblend = 0,
            highlights = {
                border = "Normal",
                background = "Normal",
            },
        },
    },
}
