return {
    "ibhagwan/fzf-lua",

    -- The `cmd` trigger ensures the plugin loads if you manually run `:FzfLua`.
    -- The `keys` below will also act as triggers.
    cmd = "FzfLua",
    event = "VeryLazy",

    dependencies = { "nvim-tree/nvim-web-devicons" },

    opts = {
        keymap = {
            fzf = {
                ["ctrl-q"] = "select-all+accept",
            },
        },
    },

    keys = {
        -- All simple mappings are converted to command strings.
        -- This is more efficient and allows lazy.nvim to use them as triggers.
        { "<leader>ff", "<cmd>FzfLua files<CR>", desc = "Find Files" },
        { "<leader>fg", "<cmd>FzfLua live_grep<CR>", desc = "Live Grep" },
        { "<leader>fh", "<cmd>FzfLua helptags<CR>", desc = "Find Help" },
        { "<leader>fk", "<cmd>FzfLua keymaps<CR>", desc = "Find Keymaps" },
        { "<leader>fb", "<cmd>FzfLua builtin<CR>", desc = "Find Builtin" },
        { "<leader>fw", "<cmd>FzfLua grep_cword<CR>", desc = "Find Word" },
        { "<leader>fW", "<cmd>FzfLua grep_cWORD<CR>", desc = "Find WORD" },
        { "<leader>fd", "<cmd>FzfLua diagnostics_document<CR>", desc = "Find Diagnostics" },
        { "<leader>fr", "<cmd>FzfLua resume<CR>", desc = "Resume FZF" },
        { "<leader>fo", "<cmd>FzfLua oldfiles<CR>", desc = "Find Old Files" },
        { "<leader><leader>", "<cmd>FzfLua buffers<CR>", desc = "Find Buffers" },
        { "<leader>/", "<cmd>FzfLua lgrep_curbuf<CR>", desc = "Grep Current Buffer" },

        -- This is a special case. Because it uses a dynamic path from a `vim.fn` call,
        -- keeping it as a function is the cleanest solution. The plugin will already be
        -- loaded by any of the other keypresses, so this has no performance penalty.
        {
            "<leader>fc",
            function()
                require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
            end,
            desc = "Find in Config",
        },
    },
}
