return {
    "stevearc/conform.nvim",
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },
            python = { "isort", "black" },
            rust = { "rustfmt" },
            javascript = { "prettierd", "prettier", stop_after_first = true },
            typescript = { "prettierd", "prettier", stop_after_first = true },
            typst = { "typstyle" },
        },
        -- Define specific arguments for each formatter
        formatters = {
            stylua = {
                prepend_args = { "--indent-type", "Tabs", "--indent-width", "4" },
            },
            prettier = {
                prepend_args = { "--use-tabs", "true", "--tab-width", "4" },
            },
            prettierd = {
                prepend_args = { "--use-tabs", "true", "--tab-width", "4" },
            },
            rustfmt = {
                -- Rustfmt often requires a rustfmt.toml, but you can force it here
                prepend_args = { "--config", "hard_tabs=true,tab_spaces=4" },
            },
        },
        format_on_save = function(bufnr)
            if vim.g.autoformat_on_save == true then
                return {
                    timeout_ms = 500,
                    lsp_format = "fallback",
                }
            end
        end,
    },
}
