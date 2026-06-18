local M = {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
        require("tiny-inline-diagnostic").setup({
            -- ── Appearance ──────────────────────────────────────────
            preset = "modern", -- "modern" | "classic" | "minimal" | "powerline" | "ghost" | "simple" | "nonerdfont" | "amongus"

            transparent_bg = false, -- make diagnostic background transparent
            transparent_cursorline = true, -- make cursorline background transparent for diagnostics

            -- Override highlight groups (Neovim highlight group names or hex "#RRGGBB")
            hi = {
                error = "DiagnosticError",
                warn = "DiagnosticWarn",
                info = "DiagnosticInfo",
                hint = "DiagnosticHint",
                arrow = "NonText", -- colour of arrow pointing to diagnostic
                background = "CursorLine", -- background highlight
                mixing_color = "Normal", -- colour to blend background with ("None" to disable)
            },

            -- Filetypes to disable the plugin for
            disabled_ft = {},

            -- ── Custom signs (overrides preset signs entirely) ──────
            -- signs = {
            --     left = "",
            --     right = "",
            --     diag = "●",
            --     arrow = "    ",
            --     up_arrow = "    ",
            --     vertical = " │",
            --     vertical_end = " └",
            -- },

            -- ── Custom blending (overrides preset blending entirely) ─
            -- blend = {
            --     factor = 0.22,
            -- },

            -- ══════════════════════════════════════════════════════════
            --  Options
            -- ══════════════════════════════════════════════════════════
            options = {
                -- ── Show diagnostic source (e.g. "lua_ls", "pyright") ─
                show_source = {
                    enabled = false,
                    if_many = false, -- only show source if multiple sources exist for the same diagnostic
                },

                -- Show diagnostic code (e.g. "F401", "no-dupe-args")
                show_code = true,

                -- Use icons from vim.diagnostic.config() instead of preset icons
                use_icons_from_diagnostic = true,

                -- Colour the arrow to match the severity of the first diagnostic
                set_arrow_to_diag_color = false,

                -- Throttle update frequency (ms) — higher = less CPU, less responsive
                throttle = 20,

                -- Minimum characters before wrapping long messages
                softwrap = 30,

                -- ── Diagnostic message display ───────────────────────
                add_messages = {
                    messages = true, -- show full diagnostic messages
                    display_count = false, -- show diagnostic count instead of messages when cursor not on line
                    use_max_severity = false, -- when counting, only show the most severe diagnostic
                    show_multiple_glyphs = true, -- show multiple icons for multiple diagnostics of same severity
                },

                -- ── Multiline diagnostics ────────────────────────────
                multilines = {
                    enabled = true, -- enable multiline diagnostic messages
                    always_show = true, -- always show diagnostics on all lines
                    trim_whitespaces = false, -- remove leading/trailing whitespace from each line
                    tabstop = 4, -- spaces per tab when expanding tabs
                    severity = {
                        vim.diagnostic.severity.ERROR,
                    },
                },

                -- Show all diagnostics on the current cursor line, not just those under the cursor
                show_all_diags_on_cursorline = false,

                -- Only show diagnostics when cursor is directly over them (no fallback to line)
                show_diags_only_under_cursor = false,

                -- ── Show related diagnostics from LSP relatedInformation ─
                show_related = {
                    enabled = true,
                    max_count = 3, -- max related diagnostics shown per diagnostic
                },

                -- Show diagnostics in insert mode (may cause visual artifacts)
                enable_on_insert = false,

                -- Show diagnostics in select mode
                enable_on_select = false,

                -- ── Overflow handling (messages wider than window) ───
                overflow = {
                    mode = "wrap", -- "wrap" | "none" | "oneline"
                    padding = 0, -- extra characters to trigger wrapping earlier
                },

                -- ── Break long messages into separate lines ──────────
                break_line = {
                    enabled = false,
                    after = 30, -- characters before inserting a line break
                },

                -- Custom formatter for diagnostic messages
                -- Receives diagnostic object, returns formatted string
                format = nil,
                -- Example:
                -- format = function(diag)
                --     return diag.message .. " [" .. diag.source .. "]"
                -- end,

                -- ── Virtual text display ─────────────────────────────
                virt_texts = {
                    priority = 2048, -- higher = render above other plugins (e.g. GitBlame)
                },

                -- ── Severity filter — remove levels you don't want ──
                severity = {
                    vim.diagnostic.severity.ERROR,
                },

                -- Events that trigger attaching diagnostics to buffers
                -- Default is {"LspAttach"}; change only if plugin doesn't work with your LSP
                overwrite_events = nil,

                -- Auto-disable diagnostics when opening diagnostic float windows
                override_open_float = false,

                -- ── Experimental ─────────────────────────────────────
                experimental = {
                    -- Don't mirror diagnostics across windows showing the same buffer
                    -- See: https://github.com/rachartier/tiny-inline-diagnostic.nvim/issues/127
                    use_window_local_extmarks = false,
                },
            },
        })
        vim.diagnostic.config({ virtual_text = false })
    end,
}

return {}
