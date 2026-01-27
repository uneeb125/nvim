local prev = { new_name = "", old_name = "" } -- Prevents duplicate events
vim.api.nvim_create_autocmd("User", {
  pattern = "NvimTreeSetup",
  callback = function()
    local events = require("nvim-tree.api").events
    events.subscribe(events.Event.NodeRenamed, function(data)
      if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
        data = data
        Snacks.rename.on_rename_file(data.old_name, data.new_name)
      end
    end)
  end,
})

return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    dependencies = {
        "nvim-web-devicons",
    },

    -- This is key change for startup performance.
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
