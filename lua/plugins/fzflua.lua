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

                local function process_and_insert_template(selected)
                    local filepath = selected[1]
                    local lines = vim.fn.readfile(filepath)

                    if lines[1] and lines[1]:match("^;;") then
                        table.remove(lines, 1)
                    end

                    local content = table.concat(lines, "\n")

                    content = content:gsub("{{_lua:(.-)_}}", function(lua_code)
                        local func = loadstring("return " .. lua_code)
                        if func then
                            local ok, res = pcall(func)
                            if ok then return tostring(res) end
                        end
                        return ""
                    end)

                    local replacements = {
                        ["{{_date_}}"] = os.date("%Y-%m-%d %H:%M:%S"),
                        ["{{_file_name_}}"] = vim.fn.expand("%:t:r"),
                        ["{{_author_}}"] = template.author or "",
                        ["{{_email_}}"] = template.email or "",
                        ["{{_variable_}}"] = vim.fn.input("Variable name: ", ""),
                        ["{{_upper_file_}}"] = string.upper(vim.fn.expand("%:t:r")),
                    }

                    for key, value in pairs(replacements) do
                        content = content:gsub(key, value)
                    end

                    local cursor_line = 0
                    local line_num = 0
                    content = content:gsub("{{_cursor_}}", function()
                        cursor_line = line_num + 1
                        return ""
                    end)

                    local buf_lines = vim.split(content, "\n")
                    local cur_line = vim.api.nvim_win_get_cursor(0)[1]
                    local start_line = cur_line == 1 and #vim.api.nvim_get_current_line() == 0 and cur_line - 1 or cur_line
                    vim.api.nvim_buf_set_lines(0, start_line, cur_line, false, buf_lines)

                    if cursor_line > 0 then
                        vim.api.nvim_win_set_cursor(0, { start_line + cursor_line, 0 })
                        vim.cmd("startinsert!")
                    end
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
                            process_and_insert_template(selected)
                        end,
                    },
                })
            end,
            desc = "Find Templates",
        },
    },
}
