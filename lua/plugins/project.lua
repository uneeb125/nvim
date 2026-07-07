return {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    -- REMOVED the `init` block.

    -- ADD a `config` block with the exact same code.
    config = function()
        require("project_nvim").setup({
            patterns = { "Cargo.toml", "pyproject.toml", "go.mod", "Gemfile", "package.json",
                "project.json", "Makefile", "setup.py", ".git", ".jj", ".hg" },
        })

        local history = require("project_nvim.utils.history")
        local project = require("project_nvim.project")

        vim.api.nvim_create_user_command("DetectProject", function()
            local bufpath = vim.api.nvim_buf_get_name(0)
            if bufpath == "" then return end
            local dir = vim.fn.fnamemodify(bufpath, ":h")
            local root = vim.fs.root(dir, { "Cargo.toml", "pyproject.toml", "go.mod", "Gemfile", "package.json",
                "project.json", "Makefile", "setup.py", ".git", ".jj", ".hg" })
            if root then
                if project.set_pwd(root, "detect") then
                    vim.notify("Project detected: " .. root)
                end
            else
                vim.notify("No project root found", vim.log.levels.WARN)
            end
        end, {})

        vim.api.nvim_create_user_command("SetProject", function()
            local bufpath = vim.api.nvim_buf_get_name(0)
            local default = bufpath ~= "" and vim.fn.fnamemodify(bufpath, ":h") or vim.fn.getcwd()
            local path = vim.fn.input("Set project directory: ", default, "dir")
            if path ~= "" then
                if project.set_pwd(path, "manual") then
                    vim.notify("Project set to: " .. path)
                end
            end
        end, {})

        vim.api.nvim_create_user_command("FzfProjects", function()
            local projects = history.get_recent_projects()

            require("fzf-lua").fzf_exec(projects, {
                prompt = "Projects> ",
                actions = {
                    ["default"] = function(selected)
                        if selected and #selected > 0 then
                            local project_path = selected[1]
                            if project.set_pwd(project_path, "fzf-lua") then
                                require("fzf-lua").files()
                            end
                        end
                    end,
                },
            })
        end, {})
    end,
    keys = {
        {
            "<leader>fp",
            "<cmd>FzfProjects<CR>",
            desc = "Find Recent Projects",
        },
        {
            "<leader>ps",
            "<cmd>SetProject<CR>",
            desc = "Set Project Directory",
        },
        {
            "<leader>pr",
            "<cmd>ProjectRoot<CR>",
            desc = "Toggle Project Root",
        },
        {
            "<leader>pd",
            "<cmd>DetectProject<CR>",
            desc = "Auto-Detect Project from File",
        },
        {
            "<leader>pa",
            "<cmd>lua require('project_nvim.project').set_pwd(vim.fn.getcwd(), 'manual')<CR>",
            desc = "Add Current Dir as Project",
        },
    },
}
