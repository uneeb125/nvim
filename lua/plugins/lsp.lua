return {
    "neovim/nvim-lspconfig",

    -- `event = "VeryLazy"` is the key to performance. This entire file and its
    -- dependencies will not be loaded until you open a file.
    event = "VeryLazy",

    dependencies = {
        -- LSP Server & Tool Management
        { "williamboman/mason.nvim", opts = {} },
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",

        -- UI for LSP progress
        { "j-hui/fidget.nvim", opts = {} },
    },

    config = function()
        -- Define a helper function for creating buffer-local keymaps.
        local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = true, desc = "LSP: " .. desc })
        end

        -- The `on_attach` function runs each time a language server attaches to a buffer.
        -- We are using a minimal version for debugging.
        local on_attach = function(client, bufnr)
            vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
        end

        -- Configure diagnostic signs and virtual text.
        vim.diagnostic.config({
            severity_sort = true,
            virtual_text = false,
            float = { border = "rounded", source = "if_many" },
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "󰅚",
                    [vim.diagnostic.severity.WARN] = "󰀪",
                    [vim.diagnostic.severity.INFO] = "󰋽",
                    [vim.diagnostic.severity.HINT] = "󰌶",
                },
            },
        })

        -- Get LSP capabilities from blink.cmp.
        local capabilities = require("blink.cmp").get_lsp_capabilities()
        -- Enable LSP snippet support (blink.cmp will use LuaSnip to expand them)
        capabilities.textDocument.completion.completionItem.snippetSupport = true

        -- Define the list of LSP servers and tools you want to use.
        local servers = {
            -- LSPs
            bashls = {},
            marksman = {},
            lua_ls = {},
            texlab = {},
            ltex_plus = {},
            -- Add more LSPs here...

            -- Linters / Formatters
            "stylua",
            "prettierd",
        }

        require("mason-lspconfig").setup({
            handlers = {
                function(server_name)
                    local server_opts = {
                        on_attach = on_attach,
                        capabilities = capabilities,
                    }
                    if server_name == "ltex_plus" then
                        server_opts.on_attach = function(client, bufnr)
                            on_attach(client, bufnr) -- call original on_attach
                            require("ltex_extra").setup({ init_check = false })
                        end
                        server_opts.debounce_text_changes = 1500
                        server_opts.settings = {
                            ltex = {
                                checkTriggers = "onType",
                            },
                        }
                    end
                    require("lspconfig")[server_name].setup(server_opts)
                end,
            },
        })

        -- Set up mason-tool-installer to automatically install the servers and tools.
        require("mason-tool-installer").setup({
            ensure_installed = servers,
        })
    end,
}
