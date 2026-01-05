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

        -- Find in Config
        {
            "<leader>fc",
            function()
                require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
            end,
            desc = "Find in Config",
        },

        -- Find and insert templates
        {
            "<leader>ft",
            function()
                local fzf_lua = require("fzf-lua")
                local template = require("template")
                local current_filetype = vim.bo.filetype

                local template_list = template.get_temp_list()

                if not template_list or vim.tbl_isempty(template_list) then
                    vim.notify("No templates found in: " .. template.temp_dir, vim.log.levels.WARN)
                    return
                end

                if not template_list[current_filetype] then
                    vim.notify("No templates found for filetype: " .. current_filetype, vim.log.levels.WARN)
                    vim.notify("Available filetypes: " .. table.concat(vim.tbl_keys(template_list), ", "), vim.log.levels.INFO)
                    return
                end

                fzf_lua.fzf_exec(template_list[current_filetype], {
                    prompt = string.format("Templates [%s]> ", current_filetype),
                    previewer = "builtin",
                    fn_transform = function(x)
                        local rel_path = vim.fn.fnamemodify(x, ":.")
                        return rel_path:gsub("^templates/", "")
                    end,
                    actions = {
                        ["default"] = function(selected)
                            if not selected or #selected == 0 then
                                return
                            end
                            local template_file = selected[1]
                            local template_name_only = vim.fn.fnamemodify(template_file, ":t:r")
                            vim.cmd("Template " .. template_name_only)
                        end,
                    },
                })
            end,
            desc = "Find Templates",
        },
    },
}
