return {
    "sudo-tee/opencode.nvim",
    dependencies = {
        { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    },
    opts = {
        preferred_picker = "fzf",
        preferred_completion = "blink",
        default_global_keymaps = true,
        default_mode = "build",
        keymap_prefix = "<leader>o",
        opencode_executable = "opencode",

        server = {
            url = nil,
            port = nil,
            timeout = 5,
            auto_kill = true,
        },

        keymap = {
            editor = {
                ["<leader>og"] = { "toggle", desc = "Toggle Opencode" },
                ["<leader>oi"] = { "open_input", desc = "Open input" },
                ["<leader>oI"] = { "open_input_new_session", desc = "New session" },
                ["<leader>oo"] = { "open_output", desc = "Open output" },
                ["<leader>ot"] = { "toggle_focus", desc = "Toggle focus" },
                ["<leader>oT"] = { "timeline", desc = "Timeline picker" },
                ["<leader>oq"] = { "close", desc = "Close UI windows" },
                ["<leader>os"] = { "select_session", desc = "Select session" },
                ["<leader>oR"] = { "rename_session", desc = "Rename session" },
                ["<leader>op"] = { "configure_provider", desc = "Configure provider" },
                ["<leader>oV"] = { "configure_variant", desc = "Configure variant" },
                ["<leader>oy"] = { "add_visual_selection", mode = { "v" }, desc = "Add visual selection" },
                ["<leader>oY"] = { "add_visual_selection_inline", mode = { "v" }, desc = "Add selection inline" },
                ["<leader>oz"] = { "toggle_zoom", desc = "Toggle zoom" },
                ["<leader>ov"] = { "paste_image", desc = "Paste image" },
                ["<leader>ox"] = { "swap_position", desc = "Swap position" },
                ["<leader>o/"] = { "quick_chat", mode = { "n", "x" }, desc = "Quick chat" },

                ["<leader>od"] = false,
                ["<leader>odo"] = { "diff_open", desc = "Open Diff" },
                ["<leader>od]"] = { "diff_next", desc = "Next file diff" },
                ["<leader>od["] = { "diff_prev", desc = "Prev file diff" },
                ["<leader>odc"] = { "diff_close", desc = "Close diff view" },

                ["<leader>orr"] = false,
                ["<leader>ora"] = { "diff_revert_all_last_prompt", desc = "Revert all (last prompt)" },
                ["<leader>ort"] = { "diff_revert_this_last_prompt", desc = "Revert this (last prompt)" },
            },
            input_window = {
                ["<S-cr>"] = { "submit_input_prompt", mode = { "n", "i" }, desc = "Submit prompt" },
                ["<esc>"] = { "close", defer_to_completion = true, desc = "Close UI" },
                ["<C-c>"] = { "cancel", defer_to_completion = true, desc = "Cancel request" },
                ["<tab>"] = { "toggle_pane", mode = { "n", "i" }, defer_to_completion = true, desc = "Toggle pane" },
            },
            output_window = {
                ["<esc>"] = { "close", desc = "Close UI" },
                ["<C-c>"] = { "cancel", desc = "Cancel request" },
                ["]]"] = { "next_message", desc = "Next message" },
                ["[["] = { "prev_message", desc = "Prev message" },
                ["i"] = { "focus_input", "n", desc = "Focus input" },
            },
        },

        ui = {
            enable_treesitter_markdown = true,
            position = "right",
            persist_state = true,
            icons = { preset = "nerdfonts" },
            output = { filetype = "opencode_output" },
        },

        hooks = {
            on_file_edited = function(file_path)
                if type(file_path) == "string" and file_path ~= "" then
                    vim.schedule(function()
                        -- Automated edits still open in tabs for visualization
                        vim.cmd("tabedit " .. vim.fn.fnameescape(file_path))
                        pcall(function()
                            vim.cmd("normal! `]")
                            vim.cmd("normal! zz")
                        end)
                    end)
                end
            end,
        },
    },

    config = function(_, opts)
        vim.o.autoread = true
        require("opencode").setup(opts)

        -- 1. Revert Keymap (Focus stays locked to code)
        vim.keymap.set("n", "<leader>orr", function()
            local current_win = vim.api.nvim_get_current_win()
            require("opencode.api").diff_revert_this_last_prompt()
            vim.schedule(function()
                if vim.api.nvim_win_is_valid(current_win) then
                    vim.api.nvim_set_current_win(current_win)
                end
            end)
        end, { desc = "Instantly Revert AI edit" })

        -- 2. UNIVERSAL SMART JUMP: Opens as Buffer or Tab
        local function smart_jump(target)
            local line = vim.api.nvim_get_current_line()

            -- Regex to find filenames in chat history
            local file = line:match("%*%*%w+%*%*%s+'([^']+)'") or line:match("`([^`]+)`") or line:match("'([^']+)'")

            if file and file ~= "" and not file:match("[%[%]%(%)]") then
                if target == "tab" then
                    -- Open in new tab
                    vim.cmd("tabedit " .. vim.fn.fnameescape(file))
                else
                    -- JUMP TO EDITOR: Use the plugin API to move focus out of the locked chat window
                    require("opencode.api").toggle_focus()

                    -- Now we are in the editor window, open the buffer
                    vim.cmd("edit " .. vim.fn.fnameescape(file))
                end
                vim.cmd("normal! zz")
                return
            end

            -- Fallback if no file found
            local key_code = (target == "tab") and "O" or "<CR>"
            local key = vim.api.nvim_replace_termcodes(key_code, true, false, true)
            vim.api.nvim_feedkeys(key, "n", false)
        end

        -- Apply keymaps to the chat output window
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "opencode_output",
            callback = function(event)
                -- o and Enter -> Use toggle_focus to jump to editor, then open buffer
                vim.keymap.set("n", "o", function()
                    smart_jump("buffer")
                end, { buffer = event.buf, desc = "Open in editor" })
                vim.keymap.set("n", "<CR>", function()
                    smart_jump("buffer")
                end, { buffer = event.buf, desc = "Open in editor" })

                -- O -> Open in new Tab (does not trigger winfixbuf error)
                vim.keymap.set("n", "O", function()
                    smart_jump("tab")
                end, { buffer = event.buf, desc = "Open in new tab" })
            end,
        })
    end,
}
