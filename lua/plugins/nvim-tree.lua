return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    dependencies = {
        "nvim-web-devicons",
    },

    -- This is the key change for startup performance.
    -- The plugin will now only load when you run one of these commands.
    cmd = { "NvimTreeToggle", "NvimTreeFindFile", "NvimTreeFocus" },

    opts = {
        on_attach = function(bufnr)
            local api = require("nvim-tree.api")

            local function opts(desc)
                return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end

            api.config.mappings.default_on_attach(bufnr)

            vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
            vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
            vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
        end,

        update_focused_file = {
            enable = true,
            update_cwd = true,
        },

        renderer = {
            icons = {
                glyphs = {
                    default = "",
                    symlink = "",
                    folder = {
                        arrow_open = "",
                        arrow_closed = "",
                        default = "",
                        open = "",
                        empty = "",
                        empty_open = "",
                        symlink = "",
                        symlink_open = "",
                    },
                    git = {
                        unstaged = "",
                        staged = "S",
                        unmerged = "",
                        renamed = "➜",
                        untracked = "U",
                        deleted = "",
                        ignored = "◌",
                    },
                },
            },
        },

        diagnostics = {
            enable = true,
            show_on_dirs = true,
            icons = {
                hint = "󰌵",
                info = "",
                warning = "",
                error = "",
            },
        },

        view = {
            width = 30,
            side = "left",
        },
    },
}
