return {
    "lvim-tech/lvim-dependencies",
    event = "VeryLazy",
    dependencies = {
        { "lvim-tech/lvim-utils" },
    },
    config = function()
        require("lvim-dependencies").setup({
            notify = {
                enabled = true,
                min_level = vim.log.levels.INFO,
                title = "Lvim Dependencies",
                timeout = 10000,
            },
            debug = {
                enabled = true,
                min_level = vim.log.levels.DEBUG,
            },
            highlight = {
                colors = {
                    bg            = "#1a1f21",
                    fg            = "#646c62",
                    separator     = "#486b4c",
                    declared      = "#bb755e",
                    installed     = "#f0c776",
                    loading       = "#6e8068",
                    working       = "#6e8068",
                    error         = "#ce5f57",
                    success       = "#3a6479",
                    title         = "#7954c6",
                    sub_title     = "#7954c6",
                    subject       = "#f0c776",
                    info          = "#545ec6",
                    navigation    = "#6e8068",
                    line_active   = "#4b809b",
                    line_inactive = "#43728a",
                    input         = "#43728a",
                },
            },
            ui = {
                virtual_text = {
                    position = nil,
                    status = {
                        enabled = { default = true },
                    },
                    icons = {
                        separators = {
                            prefix     = "➤➤➤",
                            transition = "→",
                            divider    = "|",
                        },
                        up_to_date = "",
                        outdated   = "",
                        loading    = "Loading...",
                        working    = "Working... ",
                        error      = "?",
                    },
                },
                popup = {
                    border     = { " ", " ", " ", " ", " ", " ", " ", " " },
                    width      = "auto",
                    height     = "auto",
                    max_height = 0.8,
                    current    = "➤",
                    max_items  = 20,
                },
                float = {
                    border     = { " ", " ", " ", " ", " ", " ", " ", " " },
                    width      = "auto",
                    height     = "auto",
                    max_height = 0.8,
                },
            },
            lsp = {
                enabled = true,
                on_attach = function(_, bufnr)
                    vim.keymap.set("n", "K", function()
                        vim.lsp.buf.hover()
                    end, { buffer = bufnr, desc = "Lvim Dependencies: Show hover" })
                    vim.keymap.set("n", "ga", function()
                        vim.lsp.buf.code_action()
                    end, { buffer = bufnr, desc = "Lvim Dependencies: Code actions" })
                end,
                actions = true,
                hover   = true,
            },
            cache = {
                ttl = {
                    installed = 300,
                    latest    = 1800,
                    manifest  = 3600,
                    declared  = nil,
                },
                cleanup = {
                    interval    = 3600000,
                    threshold   = 0.8,
                    max_entries = 1000,
                },
                stats = {
                    collect        = true,
                    warn_threshold = 500,
                },
                managers_cache_ttl      = 5000,
                manifest_type_cache_ttl = 5000,
            },
            async = {
                defaults = {
                    concurrency     = 10,
                    timeout         = 5000,
                    retry_count     = 3,
                    retry_delay     = 1000,
                    max_retry_delay = 5000,
                },
                package_loader = {
                    concurrency = 10,
                    retry_count = 3,
                    retry_delay = 1000,
                },
                operator = {
                    retry_count = 2,
                    retry_delay = 2000,
                },
                file_operations = {
                    read_timeout = 3000,
                },
                debounce = {
                    save = 200,
                    move = 50,
                },
                throttle = {
                    default_limit = 100,
                },
            },
            npm = {
                executables = {
                    npm  = nil,
                    yarn = nil,
                    pnpm = nil,
                },
                preferred_manager = nil,
                api = {
                    timeout       = 10,
                    registry_base = nil,
                    endpoint      = nil,
                },
                file_ops = {
                    root_dir = nil,
                },
                version = {
                    include_prerelease = false,
                    sort_order         = "desc",
                    max_versions       = 50,
                },
                sections = {
                    order   = { "dependencies", "devDependencies", "peerDependencies", "optionalDependencies" },
                    default = "dependencies",
                },
                virtual_text = {
                    position = nil,
                    priority = nil,
                },
                polling = {
                    max_attempts   = 30,
                    interval_ms    = 200,
                    start_delay_ms = 500,
                },
            },
            cargo = {
                executables = {
                    cargo = nil,
                    rustc = nil,
                },
                api = {
                    timeout       = 10,
                    registry_base = nil,
                    endpoint      = nil,
                },
                file_ops = {
                    root_dir = nil,
                },
                version = {
                    include_prerelease = false,
                    sort_order         = "desc",
                    max_versions       = 50,
                },
                display = {
                    show_features         = true,
                    filter_default        = true,
                    show_optional         = false,
                    show_default_features = false,
                    max_features_display  = 3,
                    truncation_indicator  = "...",
                },
                virtual_text = {
                    position = nil,
                    priority = nil,
                },
                polling = {
                    max_attempts   = 30,
                    interval_ms    = 200,
                    start_delay_ms = 500,
                },
            },
            go = {
                executables = {
                    go = nil,
                },
                api = {
                    timeout    = 10,
                    proxy_base = nil,
                },
                file_ops = {
                    root_dir = nil,
                },
                version = {
                    include_prerelease = false,
                    sort_order         = "desc",
                    max_versions       = 50,
                },
                virtual_text = {
                    position = nil,
                    priority = nil,
                },
                polling = {
                    max_attempts   = 30,
                    interval_ms    = 200,
                    start_delay_ms = 500,
                },
            },
            composer = {
                executables = {
                    composer = nil,
                },
                api = {
                    timeout       = 10,
                    registry_base = nil,
                    endpoint      = nil,
                },
                file_ops = {
                    root_dir = nil,
                },
                version = {
                    include_prerelease = false,
                    sort_order         = "desc",
                    max_versions       = 50,
                },
                sections = {
                    order   = { "require", "require-dev" },
                    default = "require",
                },
                polling = {
                    max_attempts   = 30,
                    interval_ms    = 200,
                    start_delay_ms = 500,
                },
            },
            pubspec = {
                executables = {
                    flutter = nil,
                    dart    = nil,
                },
                api = {
                    timeout       = 10,
                    registry_base = nil,
                    endpoint      = nil,
                },
                file_ops = {
                    root_dir      = nil,
                    file_patterns = nil,
                },
                version = {
                    include_prerelease = true,
                    sort_order         = "desc",
                    max_versions       = 50,
                },
                sections = {
                    order   = { "dependencies", "dev_dependencies", "dependency_overrides" },
                    default = "dependencies",
                },
                sdk_packages = {},
                virtual_text = {
                    position = nil,
                    priority = nil,
                },
                polling = {
                    max_attempts   = 30,
                    interval_ms    = 200,
                    start_delay_ms = 500,
                },
            },
        })

        vim.keymap.set("n", "<leader>du", "<cmd>LvimDeps update<cr>",  { desc = "Update dependency" })
        vim.keymap.set("n", "<leader>di", "<cmd>LvimDeps install<cr>", { desc = "Install dependency" })
        vim.keymap.set("n", "<leader>dd", "<cmd>LvimDeps delete<cr>",  { desc = "Delete dependency" })
        vim.keymap.set("n", "<leader>dr", "<cmd>LvimDeps toggle<cr>",  { desc = "Toggle dependency virtual text" })
    end,
}
