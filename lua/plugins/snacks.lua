return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
        {
            "<leader>.",
            function()
                Snacks.scratch()
            end,
            desc = "Toggle Scratch Buffer",
        },
        {
            "<leader>S",
            function()
                Snacks.scratch.select()
            end,
            desc = "Select Scratch Buffer",
        },
    },
    ---@type snacks.Config
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        animate = {
            enabled = true,
            easing = "outQuad",
            duration = 20,
            fps = 30,
        },
        bigfile = {
            enabled = true,
            notify = true,
            size = 1.5 * 1024 * 1024,
            line_length = 5000,
            setup = function(ctx)
                if vim.fn.exists(":NoMatchParen") ~= 0 then
                    vim.cmd([[NoMatchParen]])
                end
                Snacks.util.wo(0, { foldmethod = "manual", statuscolumn = "", conceallevel = 0 })
                vim.b.completion = false
                vim.b.minianimate_disable = true
                vim.b.minihipatterns_disable = true
                vim.schedule(function()
                    if vim.api.nvim_buf_is_valid(ctx.buf) then
                        vim.bo[ctx.buf].syntax = ctx.ft
                    end
                end)
            end,
        },
        dashboard = { enabled = true },
        dim = {
            enabled = true,
            scope = {
                min_size = 5,
                max_size = 20,
                siblings = true,
            },
            animate = {
                enabled = vim.fn.has("nvim-0.10") == 1,
                easing = "outQuad",
                duration = {
                    step = 20,
                    total = 300,
                },
            },
            filter = function(buf)
                return vim.g.snacks_dim ~= false and vim.b[buf].snacks_dim ~= false and vim.bo[buf].buftype == ""
            end,
        },
        explorer = { enabled = true },
        indent = {
            enabled = true,
            indent = {
                priority = 1,
                enabled = true,
                char = "│",
                only_scope = false,
                only_current = false,
                hl = "SnacksIndent",
            },
            animate = {
                enabled = vim.fn.has("nvim-0.10") == 1,
                style = "out",
                easing = "linear",
                duration = {
                    step = 20,
                    total = 500,
                },
            },
            scope = {
                enabled = true,
                priority = 200,
                char = "│",
                underline = false,
                only_current = false,
                hl = "SnacksIndentScope",
            },
            chunk = {
                enabled = false,
                only_current = false,
                priority = 200,
                hl = "SnacksIndentChunk",
                char = {
                    corner_top = "┌",
                    corner_bottom = "└",
                    horizontal = "─",
                    vertical = "│",
                    arrow = ">",
                },
            },
            filter = function(buf, win)
                return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == ""
            end,
        },
        input = {
            enabled = true,
            icon = " ",
            icon_hl = "SnacksInputIcon",
            icon_pos = "left",
            prompt_pos = "title",
            win = {
                backdrop = false,
                position = "float",
                border = true,
                title_pos = "center",
                height = 1,
                width = 60,
                relative = "editor",
                noautocmd = true,
                row = 2,
                wo = {
                    winhighlight = "NormalFloat:SnacksInputNormal,FloatBorder:SnacksInputBorder,FloatTitle:SnacksInputTitle",
                    cursorline = false,
                },
                bo = {
                    filetype = "snacks_input",
                    buftype = "prompt",
                },
                b = {
                    completion = false,
                },
                keys = {
                    n_esc = { "<esc>", { "cmp_close", "cancel" }, mode = "n", expr = true },
                    i_esc = { "<esc>", { "cmp_close", "stopinsert" }, mode = "i", expr = true },
                    i_cr = { "<cr>", { "cmp_accept", "confirm" }, mode = { "i", "n" }, expr = true },
                    i_tab = { "<tab>", { "cmp_select_next", "cmp" }, mode = "i", expr = true },
                    i_ctrl_w = { "<c-w>", "<c-s-w>", mode = "i", expr = true },
                    i_up = { "<up>", { "hist_up" }, mode = { "i", "n" } },
                    i_down = { "<down>", { "hist_down" }, mode = { "i", "n" } },
                    q = "cancel",
                },
            },
            expand = true,
        },
        picker = {
            enabled = true,
            prompt = " ",
            sources = {},
            focus = "input",
            show_delay = 5000,
            limit_live = 10000,
            layout = {
                cycle = true,
                preset = function()
                    return vim.o.columns >= 120 and "default" or "vertical"
                end,
            },
            matcher = {
                fuzzy = true,
                smartcase = true,
                ignorecase = true,
                sort_empty = false,
                filename_bonus = true,
                file_pos = true,
                cwd_bonus = false,
                frecency = false,
                history_bonus = false,
            },
            sort = {
                fields = { "score:desc", "#text", "idx" },
            },
            ui_select = true,
            formatters = {
                text = {
                    ft = nil,
                },
                file = {
                    filename_first = false,
                    truncate = "center",
                    min_width = 40,
                    filename_only = false,
                    icon_width = 2,
                    git_status_hl = true,
                },
                selected = {
                    show_always = false,
                    unselected = true,
                },
                severity = {
                    icons = true,
                    level = false,
                    pos = "left",
                },
            },
            previewers = {
                diff = {
                    style = "fancy",
                    cmd = { "delta" },
                    wo = {
                        breakindent = true,
                        wrap = true,
                        linebreak = true,
                        showbreak = "",
                    },
                },
                git = {
                    args = {},
                },
                file = {
                    max_size = 1024 * 1024,
                    max_line_length = 500,
                    ft = nil,
                },
                man_pager = nil,
            },
            jump = {
                jumplist = true,
                tagstack = false,
                reuse_win = false,
                close = true,
                match = false,
            },
            toggles = {
                follow = "f",
                hidden = "h",
                ignored = "i",
                modified = "m",
                regex = { icon = "R", value = false },
            },
            win = {
                input = {
                    keys = {
                        ["/"] = "toggle_focus",
                        ["<C-Down>"] = { "history_forward", mode = { "i", "n" } },
                        ["<C-Up>"] = { "history_back", mode = { "i", "n" } },
                        ["<C-c>"] = { "cancel", mode = "i" },
                        ["<C-w>"] = { "<c-s-w>", mode = { "i" }, expr = true, desc = "delete word" },
                        ["<CR>"] = { "confirm", mode = { "n", "i" } },
                        ["<Down>"] = { "list_down", mode = { "i", "n" } },
                        ["<Esc>"] = "cancel",
                        ["<S-CR>"] = { { "pick_win", "jump" }, mode = { "n", "i" } },
                        ["<S-Tab>"] = { "select_and_prev", mode = { "i", "n" } },
                        ["<Tab>"] = { "select_and_next", mode = { "i", "n" } },
                        ["<Up>"] = { "list_up", mode = { "i", "n" } },
                        ["<a-d>"] = { "inspect", mode = { "n", "i" } },
                        ["<a-f>"] = { "toggle_follow", mode = { "i", "n" } },
                        ["<a-h>"] = { "toggle_hidden", mode = { "i", "n" } },
                        ["<a-i>"] = { "toggle_ignored", mode = { "i", "n" } },
                        ["<a-r>"] = { "toggle_regex", mode = { "i", "n" } },
                        ["<a-m>"] = { "toggle_maximize", mode = { "i", "n" } },
                        ["<a-p>"] = { "toggle_preview", mode = { "i", "n" } },
                        ["<a-w>"] = { "cycle_win", mode = { "i", "n" } },
                        ["<c-a>"] = { "select_all", mode = { "n", "i" } },
                        ["<c-b>"] = { "preview_scroll_up", mode = { "i", "n" } },
                        ["<c-d>"] = { "list_scroll_down", mode = { "i", "n" } },
                        ["<c-f>"] = { "preview_scroll_down", mode = { "i", "n" } },
                        ["<c-g>"] = { "toggle_live", mode = { "i", "n" } },
                        ["<c-j>"] = { "list_down", mode = { "i", "n" } },
                        ["<c-k>"] = { "list_up", mode = { "i", "n" } },
                        ["<c-n>"] = { "list_down", mode = { "i", "n" } },
                        ["<c-p>"] = { "list_up", mode = { "i", "n" } },
                        ["<c-q>"] = { "qflist", mode = { "i", "n" } },
                        ["<c-s>"] = { "edit_split", mode = { "i", "n" } },
                        ["<c-t>"] = { "tab", mode = { "n", "i" } },
                        ["<c-u>"] = { "list_scroll_up", mode = { "i", "n" } },
                        ["<c-v>"] = { "edit_vsplit", mode = { "i", "n" } },
                        ["<c-r>#"] = { "insert_alt", mode = "i" },
                        ["<c-r>%"] = { "insert_filename", mode = "i" },
                        ["<c-r><c-a>"] = { "insert_cWORD", mode = "i" },
                        ["<c-r><c-f>"] = { "insert_file", mode = "i" },
                        ["<c-r><c-l>"] = { "insert_line", mode = "i" },
                        ["<c-r><c-p>"] = { "insert_file_full", mode = "i" },
                        ["<c-r><c-w>"] = { "insert_cword", mode = "i" },
                        ["<c-w>H"] = "layout_left",
                        ["<c-w>J"] = "layout_bottom",
                        ["<c-w>K"] = "layout_top",
                        ["<c-w>L"] = "layout_right",
                        ["?"] = "toggle_help_input",
                        ["G"] = "list_bottom",
                        ["gg"] = "list_top",
                        ["j"] = "list_down",
                        ["k"] = "list_up",
                        ["q"] = "cancel",
                    },
                    b = {
                        minipairs_disable = true,
                    },
                },
                list = {
                    keys = {
                        ["/"] = "toggle_focus",
                        ["<2-LeftMouse>"] = "confirm",
                        ["<CR>"] = "confirm",
                        ["<Down>"] = "list_down",
                        ["<Esc>"] = "cancel",
                        ["<S-CR>"] = { { "pick_win", "jump" } },
                        ["<S-Tab>"] = { "select_and_prev", mode = { "n", "x" } },
                        ["<Tab>"] = { "select_and_next", mode = { "n", "x" } },
                        ["<Up>"] = "list_up",
                        ["<a-d>"] = "inspect",
                        ["<a-f>"] = "toggle_follow",
                        ["<a-h>"] = "toggle_hidden",
                        ["<a-i>"] = "toggle_ignored",
                        ["<a-m>"] = "toggle_maximize",
                        ["<a-p>"] = "toggle_preview",
                        ["<a-w>"] = "cycle_win",
                        ["<c-a>"] = "select_all",
                        ["<c-b>"] = "preview_scroll_up",
                        ["<c-d>"] = "list_scroll_down",
                        ["<c-f>"] = "preview_scroll_down",
                        ["<c-j>"] = "list_down",
                        ["<c-k>"] = "list_up",
                        ["<c-n>"] = "list_down",
                        ["<c-p>"] = "list_up",
                        ["<c-q>"] = "qflist",
                        ["<c-g>"] = "print_path",
                        ["<c-s>"] = "edit_split",
                        ["<c-t>"] = "tab",
                        ["<c-u>"] = "list_scroll_up",
                        ["<c-v>"] = "edit_vsplit",
                        ["<c-w>H"] = "layout_left",
                        ["<c-w>J"] = "layout_bottom",
                        ["<c-w>K"] = "layout_top",
                        ["<c-w>L"] = "layout_right",
                        ["?"] = "toggle_help_list",
                        ["G"] = "list_bottom",
                        ["gg"] = "list_top",
                        ["i"] = "focus_input",
                        ["j"] = "list_down",
                        ["k"] = "list_up",
                        ["q"] = "cancel",
                        ["zb"] = "list_scroll_bottom",
                        ["zt"] = "list_scroll_top",
                        ["zz"] = "list_scroll_center",
                    },
                    wo = {
                        conceallevel = 2,
                        concealcursor = "nvc",
                    },
                },
                preview = {
                    keys = {
                        ["<Esc>"] = "cancel",
                        ["q"] = "cancel",
                        ["i"] = "focus_input",
                        ["<a-w>"] = "cycle_win",
                    },
                },
            },
            icons = {
                files = {
                    enabled = true,
                    dir = "󰉋 ",
                    dir_open = "󰝰 ",
                    file = "󰈔 ",
                },
                keymaps = {
                    nowait = "󰓅 ",
                },
                tree = {
                    vertical = "│ ",
                    middle = "├╴",
                    last = "└╴",
                },
                undo = {
                    saved = " ",
                },
                ui = {
                    live = "󰐰 ",
                    hidden = "h",
                    ignored = "i",
                    follow = "f",
                    selected = "● ",
                    unselected = "○ ",
                },
                git = {
                    enabled = true,
                    commit = "󰜘 ",
                    staged = "●",
                    added = "",
                    deleted = "",
                    ignored = " ",
                    modified = "○",
                    renamed = "",
                    unmerged = " ",
                    untracked = "?",
                },
                diagnostics = {
                    Error = " ",
                    Warn = " ",
                    Hint = " ",
                    Info = " ",
                },
                lsp = {
                    unavailable = "",
                    enabled = " ",
                    disabled = " ",
                    attached = "󰖩 ",
                },
                kinds = {
                    Array = " ",
                    Boolean = "󰨙 ",
                    Class = " ",
                    Color = " ",
                    Control = " ",
                    Collapsed = " ",
                    Constant = "󰏿 ",
                    Constructor = " ",
                    Copilot = " ",
                    Enum = " ",
                    EnumMember = " ",
                    Event = " ",
                    Field = " ",
                    File = " ",
                    Folder = " ",
                    Function = "󰊕 ",
                    Interface = " ",
                    Key = " ",
                    Keyword = " ",
                    Method = "󰊕 ",
                    Module = " ",
                    Namespace = "󰦮 ",
                    Null = " ",
                    Number = "󰎠 ",
                    Object = " ",
                    Operator = " ",
                    Package = " ",
                    Property = " ",
                    Reference = " ",
                    Snippet = "󱄽 ",
                    String = " ",
                    Struct = "󰆼 ",
                    Text = " ",
                    TypeParameter = " ",
                    Unit = " ",
                    Unknown = " ",
                    Value = " ",
                    Variable = "󰀫 ",
                },
            },
            db = {
                sqlite3_path = nil,
            },
            debug = {
                scores = false,
                leaks = false,
                explorer = false,
                files = false,
                grep = false,
                proc = false,
                extmarks = false,
            },
        },
        notifier = {
            enabled = true,
            timeout = 3000,
            width = { min = 40, max = 0.4 },
            height = { min = 1, max = 0.6 },
            margin = { top = 0, right = 1, bottom = 0 },
            padding = true,
            gap = 0,
            sort = { "level", "added" },
            level = vim.log.levels.TRACE,
            icons = {
                error = " ",
                warn = " ",
                info = " ",
                debug = " ",
                trace = " ",
            },
            keep = function(notif)
                return vim.fn.getcmdpos() > 0
            end,
            style = "compact",
            top_down = true,
            date_format = "%R",
            more_format = " ↓ %d lines ",
            refresh = 50,
        },
        quickfile = {
            enabled = true,
            exclude = { "latex" },
        },
        scope = {
            enabled = true,
            min_size = 2,
            max_size = nil,
            cursor = true,
            edge = true,
            siblings = false,
            filter = function(buf)
                return vim.bo[buf].buftype == "" and vim.b[buf].snacks_scope ~= false and vim.g.snacks_scope ~= false
            end,
            debounce = 100,
            treesitter = {
                enabled = true,
                injections = true,
                blocks = {
                    enabled = true,
                    "function_declaration",
                    "function_definition",
                    "method_declaration",
                    "method_definition",
                    "class_declaration",
                    "class_definition",
                    "do_statement",
                    "while_statement",
                    "repeat_statement",
                    "if_statement",
                    "for_statement",
                },
                field_blocks = {
                    "local_declaration",
                },
            },
            keys = {
                textobject = {
                    ii = {
                        min_size = 2,
                        edge = false,
                        cursor = false,
                        treesitter = { blocks = { enabled = false } },
                        desc = "inner scope",
                    },
                    ai = {
                        cursor = false,
                        min_size = 2,
                        treesitter = { blocks = { enabled = false } },
                        desc = "full scope",
                    },
                },
                jump = {
                    ["[i"] = {
                        min_size = 1,
                        bottom = false,
                        cursor = false,
                        edge = true,
                        treesitter = { blocks = { enabled = false } },
                        desc = "jump to top edge of scope",
                    },
                    ["]i"] = {
                        min_size = 1,
                        bottom = true,
                        cursor = false,
                        edge = true,
                        treesitter = { blocks = { enabled = false } },
                        desc = "jump to bottom edge of scope",
                    },
                },
            },
        },
        scratch = {
            name = "Scratch",
            ft = function()
                if vim.bo.buftype == "" and vim.bo.filetype ~= "" then
                    return vim.bo.filetype
                end
                return "markdown"
            end,
            icon = nil,
            root = vim.fn.stdpath("data") .. "/scratch",
            autowrite = true,
            filekey = {
                id = nil,
                cwd = true,
                branch = true,
                count = true,
            },
            win = { style = "scratch" },
            win_by_ft = {
                lua = {
                    keys = {
                        ["source"] = {
                            "<cr>",
                            function(self)
                                local name = "scratch." .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.buf), ":e")
                                Snacks.debug.run({ buf = self.buf, name = name })
                            end,
                            desc = "Source buffer",
                            mode = { "n", "x" },
                        },
                    },
                },
            },
        },
        scroll = {
            enabled = false,
            animate = {
                duration = { step = 20, total = 200 },
                easing = "linear",
            },
            animate_repeat = {
                delay = 100,
                duration = { step = 5, total = 50 },
                easing = "linear",
            },
            filter = function(buf)
                return vim.g.snacks_scroll ~= false
                    and vim.b[buf].snacks_scroll ~= false
                    and vim.bo[buf].buftype ~= "terminal"
            end,
        },
        statuscolumn = {
            enabled = true,
            left = { "mark", "sign" },
            right = { "fold", "git" },
            folds = {
                open = false,
                git_hl = false,
            },
            git = {
                patterns = { "GitSign", "MiniDiffSign" },
            },
            refresh = 50,
        },
        terminal = {
            enabled = true,
            win = { style = "terminal" },
            shell = nil,
            override = nil,
        },
        win = {
            show = true,
            fixbuf = true,
            relative = "editor",
            position = "float",
            minimal = true,
            wo = {
                winhighlight = "Normal:SnacksNormal,NormalNC:SnacksNormalNC,WinBar:SnacksWinBar,WinBarNC:SnacksWinBarNC,FloatTitle:SnacksTitle,FloatFooter:SnacksFooter,WinSeparator:SnacksWinSeparator",
            },
            bo = {},
            title_pos = "center",
            keys = {
                q = "close",
            },
            footer_pos = "center",
            footer_keys = false,
        },
        words = {
            enabled = true,
            debounce = 200,
            notify_jump = false,
            notify_end = true,
            foldopen = true,
            jumplist = true,
            modes = { "n", "i", "c" },
            filter = function(buf)
                return vim.g.snacks_words ~= false and vim.b[buf].snacks_words ~= false
            end,
        },
        zen = {
            toggles = {
                dim = true,
                git_signs = false,
                mini_diff_signs = false,
            },
            center = true,
            show = {
                statusline = false,
                tabline = false,
            },
            win = { style = "zen" },
            on_open = function(win) end,
            on_close = function(win) end,
            zoom = {
                toggles = {},
                center = false,
                show = { statusline = true, tabline = true },
                win = {
                    backdrop = false,
                    width = 0,
                },
            },
        },
    },
}
