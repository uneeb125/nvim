return {
    "stevearc/conform.nvim",
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },
            python = { "isort", "black" },
            rust = { "rustfmt" },
            javascript = { "prettierd", "prettier", stop_after_first = true },
            typescript = { "prettierd", "prettier", stop_after_first = true },
        },
        format_on_save = function(bufnr)
            -- Only format on save when the global variable is explicitly true
            if vim.g.autoformat_on_save == true then
                return {
                    timeout_ms = 500,
                    lsp_format = "fallback",
                }
            end
        end,
    },
}
