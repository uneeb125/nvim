return {
    "sudo-tee/opencode.nvim",
    dependencies = {
        { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    },
    opts = {
        preferred_picker = "fzf",
        preferred_completion = "blink",
        default_global_keymaps = true,
        default_mode = "dumbass",
        default_system_prompt = nil,
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
                ["<S-cr>"] = { "submit_input_prompt", mode = { "n", "i" } }, -- Submit prompt (normal mode and insert mode)
                ["<C-cr>"] = { "submit_input_prompt", mode = { "n", "i" } }, -- Submit prompt (normal mode and insert mode)
                ["<cr>"] = { "submit_input_prompt", mode = { "n" } }, -- Submit prompt (normal mode and insert mode)
                ["<esc>"] = { "close", defer_to_completion = true }, -- Close UI windows
                ["<C-c>"] = { "cancel", defer_to_completion = true }, -- Cancel opencode request while it is running
                ["<leader>oa"] = { "select_agent", desc = "Select agent/mode" },
                ["~"] = { "mention_file", mode = "i" }, -- Pick a file and add to context. See File Mentions section
                ["@"] = { "mention", mode = "i" }, -- Insert mention (file/agent)
                ["/"] = { "slash_commands", mode = "i" }, -- Pick a command to run in the input window
                ["#"] = { "context_items", mode = "i" }, -- Manage context items (current file, selection, diagnostics, mentioned files)
                ["<M-v>"] = { "paste_image", mode = "i" }, -- Paste image from clipboard as attachment
                ["<tab>"] = { "toggle_pane", mode = { "n", "i" }, defer_to_completion = true }, -- Toggle between input and output panes
                ["<up>"] = { "prev_prompt_history", mode = { "n", "i" }, defer_to_completion = true }, -- Navigate to previous prompt in history
                ["<down>"] = { "next_prompt_history", mode = { "n", "i" }, defer_to_completion = true }, -- Navigate to next prompt in history
                ["<M-m>"] = { "switch_mode" }, -- Switch between modes (build/plan)
                ["<M-r>"] = { "cycle_variant", mode = { "n", "i" } }, -- Cycle through available model variants
            },
            output_window = {
                ["<esc>"] = { "close" }, -- Close UI windows
                ["<C-c>"] = { "cancel" }, -- Cancel opencode request while it is running
                ["]]"] = { "next_message" }, -- Navigate to next message in the conversation
                ["[["] = { "prev_message" }, -- Navigate to previous message in the conversation
                ["<tab>"] = { "toggle_pane", mode = { "n", "i" } }, -- Toggle between input and output panes
                ["i"] = { "focus_input", "n" }, -- Focus on input window and enter insert mode at the end of the input from the output window
                ["<M-r>"] = { "cycle_variant", mode = { "n" } }, -- Cycle through available model variants
                ["<leader>oS"] = { "select_child_session" }, -- Select and load a child session
                ["<leader>oD"] = { "debug_message" }, -- Open raw message in new buffer for debugging
                ["<leader>oO"] = { "debug_output" }, -- Open raw output in new buffer for debugging
                ["<leader>ods"] = { "debug_session" }, -- Open raw session in new buffer for debugging
            },
            session_picker = {
                rename_session = { "<C-r>" }, -- Rename selected session in the session picker
                delete_session = { "<C-d>" }, -- Delete selected session in the session picker
                new_session = { "<C-s>" }, -- Create and switch to a new session in the session picker
            },
            timeline_picker = {
                undo = { "<C-u>", mode = { "i", "n" } }, -- Undo to selected message in timeline picker
                fork = { "<C-f>", mode = { "i", "n" } }, -- Fork from selected message in timeline picker
            },
            history_picker = {
                delete_entry = { "<C-d>", mode = { "i", "n" } }, -- Delete selected entry in the history picker
                clear_all = { "<C-X>", mode = { "i", "n" } }, -- Clear all entries in the history picker
            },
            model_picker = {
                toggle_favorite = { "<C-f>", mode = { "i", "n" } },
            },
            mcp_picker = {
                toggle_connection = { "<C-t>", mode = { "i", "n" } }, -- Toggle MCP server connection in the MCP picker
            },
        },

        ui = {
            enable_treesitter_markdown = true, -- Use Treesitter for markdown rendering in the output window (default: true).
            position = "right", -- 'right' (default), 'left' or 'current'. Position of the UI split. 'current' uses the current window for the output.
            input_position = "bottom", -- 'bottom' (default) or 'top'. Position of the input window
            window_width = 0.30, -- Width as percentage of editor width
            zoom_width = 0.8, -- Zoom width as percentage of editor width
            display_model = true, -- Display model name on top winbar
            display_context_size = true, -- Display context size in the footer
            display_cost = true, -- Display cost in the footer
            window_highlight = "Normal:OpencodeBackground,FloatBorder:OpencodeBorder", -- Highlight group for the opencode window
            persist_state = true, -- Keep buffers when toggling/closing UI so window state restores quickly
            icons = {
                preset = "nerdfonts", -- 'nerdfonts' | 'text'. Choose UI icon style (default: 'nerdfonts')
                overrides = {}, -- Optional per-key overrides, see section below
            },
            questions = {
                use_vim_ui_select = false, -- If true, render questions/prompts with vim.ui.select instead of showing them inline in the output buffer.
            },
            output = {
                filetype = "opencode_output", -- Filetype assigned to the output buffer (default: 'opencode_output')
                tools = {
                    show_output = true, -- Show tools output [diffs, cmd output, etc.] (default: true)
                    show_reasoning_output = false, -- Show reasoning/thinking steps output (default: true)
                },
                rendering = {
                    markdown_debounce_ms = 250, -- Debounce time for markdown rendering on new data (default: 250ms)
                    on_data_rendered = nil, -- Called when new data is rendered; set to false to disable default RenderMarkdown/Markview behavior
                },
            },
            input = {
                min_height = 0.10, -- min height of prompt input as percentage of window height
                max_height = 0.25, -- max height of prompt input as percentage of window height
                text = {
                    wrap = false, -- Wraps text inside input window
                },
                -- Auto-hide input window when prompt is submitted or focus switches to output window
                auto_hide = false,
            },
            picker = {
                snacks_layout = nil, -- `layout` opts to pass to Snacks.picker.pick({ layout = ... })
            },
            completion = {
                file_sources = {
                    enabled = true,
                    preferred_cli_tool = "server", -- 'fd','fdfind','rg','git','server' if nil, it will use the best available tool, 'server' uses opencode cli to get file list (works cross platform) and supports folders
                    ignore_patterns = {
                        "^%.git/",
                        "^%.svn/",
                        "^%.hg/",
                        "node_modules/",
                        "%.pyc$",
                        "%.o$",
                        "%.obj$",
                        "%.exe$",
                        "%.dll$",
                        "%.so$",
                        "%.dylib$",
                        "%.class$",
                        "%.jar$",
                        "%.war$",
                        "%.ear$",
                        "target/",
                        "build/",
                        "dist/",
                        "out/",
                        "deps/",
                        "%.tmp$",
                        "%.temp$",
                        "%.log$",
                        "%.cache$",
                    },
                    max_files = 10,
                    max_display_length = 50, -- Maximum length for file path display in completion, truncates from left with "..."
                },
            },
        },
        context = {
            enabled = true, -- Enable automatic context capturing
            cursor_data = {
                enabled = false, -- Include cursor position and line content in the context
                context_lines = 5, -- Number of lines before and after cursor to include in context
            },
            diagnostics = {
                info = false, -- Include diagnostics info in the context (default to false
                warning = true, -- Include diagnostics warnings in the context
                error = true, -- Include diagnostics errors in the context
                only_closest = false, -- If true, only diagnostics for cursor/selection
            },
            current_file = {
                enabled = true, -- Include current file path and content in the context
                show_full_path = true,
            },
            files = {
                enabled = true,
                show_full_path = true,
            },
            selection = {
                enabled = true, -- Include selected text in the context
            },
            buffer = {
                enabled = false, -- Disable entire buffer context by default, only used in quick chat
            },
            git_diff = {
                enabled = false,
            },
        },
        logging = {
            enabled = false,
            level = "warn", -- debug, info, warn, error
            outfile = nil,
        },
        debug = {
            enabled = false, -- Enable debug messages in the output window
            capture_streamed_events = false,
            show_ids = true,
            quick_chat = {
                keep_session = false, -- Keep quick_chat sessions for inspection, this can pollute your sessions list
                set_active_session = false,
            },
        },
        prompt_guard = nil, -- Optional function that returns boolean to control when prompts can be sent (see Prompt Guard section)

        hooks = {
            -- on_file_edited = function(file_path)
            --     if type(file_path) == "string" and file_path ~= "" then
            --         vim.schedule(function()
            --             -- Automated edits still open in tabs for visualization
            --             vim.cmd("tabedit " .. vim.fn.fnameescape(file_path))
            --             pcall(function()
            --                 vim.cmd("normal! `]")
            --                 vim.cmd("normal! zz")
            --             end)
            --         end)
            --     end
            -- end,
            on_file_edited = nil,
        },

        quick_chat = {
            default_model = "opencode/minimax-m2.5-free", -- works better with a fast model like gpt-4.1
            default_agent = nil, -- Uses the current mode when nil
            instructions = nil, -- Use built-in instructions if nil
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
        -- Added fallback_key argument to safely handle different keypresses
        local function smart_jump(target, fallback_key)
            local line = vim.api.nvim_get_current_line()

            -- Regex to find filenames in chat history
            local file = line:match("%*%*%w+%*%*%s+'([^']+)'") or line:match("`([^`]+)`") or line:match("'([^']+)'")

            if file and file ~= "" and not file:match("[%[%]%(%)]") then
                if target == "tab" then
                    -- Open in new tab
                    vim.cmd("tabedit " .. vim.fn.fnameescape(file))
                else
                    -- JUMP TO EDITOR: Move focus out of the locked chat window
                    require("opencode.api").toggle_focus()
                    -- Now we are in the editor window, open the buffer
                    vim.cmd("edit " .. vim.fn.fnameescape(file))
                end
                vim.cmd("normal! zz")
                return
            end

            -- Fallback if no file found (Using the passed fallback_key safely)
            if fallback_key then
                local key = vim.api.nvim_replace_termcodes(fallback_key, true, false, true)
                -- "n" flag is CRITICAL here. It means "noremap", which prevents the infinite loop freeze
                vim.api.nvim_feedkeys(key, "n", false)
            end
        end

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "opencode_input",
            callback = function(event)
                vim.schedule(function()
                    pcall(vim.keymap.del, "n", "<CR>", { buffer = event.buf })
                    pcall(vim.keymap.del, "v", "<CR>", { buffer = event.buf })
                end)
            end,
        })

        -- Apply keymaps to the chat output window
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "opencode_output",
            callback = function(event)
                -- o -> Use toggle_focus to jump to editor, then open buffer
                vim.keymap.set("n", "o", function()
                    smart_jump("buffer", "o")
                end, { buffer = event.buf, desc = "Open in editor" })

                -- Enter -> Use toggle_focus to jump to editor, then open buffer
                vim.keymap.set("n", "<CR>", function()
                    smart_jump("buffer", "<CR>")
                end, { buffer = event.buf, desc = "Open in editor" })

                -- O -> Open in new Tab (does not trigger winfixbuf error)
                vim.keymap.set("n", "O", function()
                    smart_jump("tab", "O")
                end, { buffer = event.buf, desc = "Open in new tab" })
            end,
        })
    end,
}
