return {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    -- The plugin loads if you open a markdown file OR press one of the keys below
    ft = "markdown",

    dependencies = {
        "nvim-lua/plenary.nvim",
    },

    -- GLOBAL KEYBINDS (Work everywhere)
    keys = {
        {
            "<leader>bd",
            function() 
                -- 1. Execute the standard command to open/create the daily note
                vim.cmd("ObsidianToday")
                
                -- 2. Switch Neovim CWD to the Vault root (optional, for consistency)
                local client = require("obsidian").get_client()
                if client then
                    local vault_path = tostring(client.dir)
                    if vim.fn.isdirectory(vault_path) == 1 then
                        vim.api.nvim_set_current_dir(vault_path)
                    end
                end
            end,
            desc = "Obsidian: Daily Note",
        },
        {
            "<leader>bi",
            function()
                local obs = require("obsidian")
                local client = obs.get_client()
                if not client then 
                    vim.notify("Obsidian client not ready", vim.log.levels.ERROR)
                    return 
                end

                vim.ui.input({ prompt = "Subfolder in xMisc: " }, function(subfolder)
                    if not subfolder or subfolder == "" then subfolder = "general" end

                    vim.ui.input({ prompt = "Note title: " }, function(title)
                        if not title or title == "" then return end

                        -- 1. Construct the path
                        local note_dir = client.dir / "xMisc" / subfolder
                        local dir_str = tostring(note_dir)

                        -- 2. Ensure directory exists
                        if vim.fn.isdirectory(dir_str) == 0 then
                            vim.fn.mkdir(dir_str, "p")
                        end

                        -- 3. Create the note
                        local note = client:create_note {
                            title = title,
                            dir = note_dir,
                        }

                        -- 4. Switch Neovim CWD to the Vault root
                        local vault_path = tostring(client.dir)
                        vim.api.nvim_set_current_dir(vault_path)

                        -- 5. Open the new note
                        vim.cmd("edit " .. vim.fn.fnameescape(tostring(note.path)))
                    end)
                end)
            end,
            desc = "Obsidian: Instant Note",
        },
    },

    opts = {
        workspaces = {
            {
                name = "personal",
                path = "~/Vault",
            },
        },

        notes_subdir = "notes",
        new_notes_location = "notes_subdir",

        note_id_func = function(title)
            local suffix = ""
            if title ~= nil then
                suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
            else
                for _ = 1, 4 do
                    suffix = suffix .. string.char(math.random(65, 90))
                end
            end
            return tostring(os.time()) .. "-" .. suffix
        end,

        daily_notes = {
            folder = "Daily",
            date_format = "%Y-%m-%d",
            alias_format = "%B %-d, %Y",
            default_tags = { "daily-notes" },
            template = nil,
        },

        completion = {
            nvim_cmp = true,
            min_chars = 2,
        },

        -- BUFFER LOCAL KEYBINDS
        -- These only make sense when you are actually editing a markdown file
        mappings = {
            ["gf"] = {
                action = function()
                    return require("obsidian").util.gf_passthrough()
                end,
                opts = { noremap = false, expr = true, buffer = true },
            },
            ["<leader>ch"] = {
                action = function()
                    return require("obsidian").util.toggle_checkbox()
                end,
                opts = { buffer = true },
            },
            ["<cr>"] = {
                action = function()
                    return require("obsidian").util.smart_action()
                end,
                opts = { buffer = true, expr = true },
            },
            -- Note: <leader>bd and <leader>bi are removed from here
            -- because they are now handled globally in `keys` above.
        },

        ui = {
            enable = true,
            hl_groups = {
                ObsidianTodo = { bold = true, fg = "#f78c6c" },
                ObsidianDone = { bold = true, fg = "#89ddff" },
                ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
                ObsidianTilde = { bold = true, fg = "#ff5370" },
                ObsidianImportant = { bold = true, fg = "#d73128" },
                ObsidianBullet = { bold = true, fg = "#89ddff" },
                ObsidianRefText = { underline = true, fg = "#c792ea" },
                ObsidianExtLinkIcon = { fg = "#c792ea" },
                ObsidianTag = { italic = true, fg = "#89ddff" },
                ObsidianBlockID = { italic = true, fg = "#89ddff" },
                ObsidianHighlightText = { bg = "#75662e" },
            },
        },

        attachments = {
            img_folder = "assets/imgs",
            img_name_func = function()
                return string.format("%s-", os.time())
            end,
        },

        -- Cross-platform url opening
        follow_url_func = function(url)
            vim.ui.open(url)
        end,
    },
}
