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
        -- This function is the core of the LSP setup. It runs only when the plugin is loaded.

        -- Define a helper function for creating buffer-local keymaps.
        local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = true, desc = "LSP: " .. desc })
        end

        -- The `on_attach` function runs each time a language server attaches to a buffer.
        local on_attach = function(client, bufnr)
            -- Keymaps for LSP functionality.
            -- Using command strings for fzf-lua calls is crucial for lazy-loading.
            -- This prevents `fzf-lua` from being required until the keymap is actually pressed.
            map("gd", "<cmd>FzfLua lsp_definitions<CR>", "[G]oto [D]efinition")
            map("gr", "<cmd>FzfLua lsp_references<CR>", "[G]oto [R]eferences")
            map("gI", "<cmd>FzfLua lsp_implementations<CR>", "[G]oto [I]mplementation")
            map("<leader>D", "<cmd>FzfLua lsp_type_definitions<CR>", "Type [D]efinition")
            map("<leader>ds", "<cmd>FzfLua lsp_document_symbols<CR>", "[D]ocument [S]ymbols")
            map("<leader>ws", "<cmd>FzfLua lsp_workspace_symbols<CR>", "[W]orkspace [S]ymbols")

            -- Keymaps for other LSP actions.
            map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
            map("<leader>cr", vim.lsp.buf.rename, "[C]ode [R]ename")
            map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

            -- Highlight references of the word under the cursor.
            if client.supports_method("textDocument/documentHighlight") then
                local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
                vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                    buffer = bufnr,
                    group = highlight_augroup,
                    callback = vim.lsp.buf.document_highlight,
                })
                vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                    buffer = bufnr,
                    group = highlight_augroup,
                    callback = vim.lsp.buf.clear_references,
                })
            end
        end

        -- Configure diagnostic signs and virtual text.
        vim.diagnostic.config({
            severity_sort = true,
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
        -- This will cause blink.cmp to load on "VeryLazy" along with this plugin,
        -- which is perfectly fine and much better than loading on startup.
        local capabilities = require("blink.cmp").get_lsp_capabilities()

        -- Define the list of LSP servers and tools you want to use.
        local servers = {
            -- LSPs
            bashls = {},
            marksman = {},
            lua_ls = {},
            -- Add more LSPs here...

            -- Linters / Formatters
            "stylua",
            "prettierd",
        }

        -- Set up mason-lspconfig to automatically attach the servers.
        require("mason-lspconfig").setup({
            handlers = {
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                    })
                end,
            },
        })

        -- Set up mason-tool-installer to automatically install the servers and tools.
        -- Since this entire file is lazy-loaded, this will only run when you open a file,
        -- so it no longer impacts your initial Neovim startup time.
        require("mason-tool-installer").setup({
            ensure_installed = servers,
        })
    end,
}
