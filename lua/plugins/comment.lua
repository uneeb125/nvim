return {
    {
        "numToStr/Comment.nvim",
        -- commit = "eab2c83a0207369900e92783f56990808082eac2",
        event = { "BufRead", "BufNewFile" },
        dependencies = {
            -- This dependency provides the logic for context-aware commenting.
            -- It is loaded automatically by lazy.nvim when the pre_hook below requires it.
            {
                "JoosepAlviste/nvim-ts-context-commentstring",
                lazy = true,
                -- commit = "729d83ecb990dc2b30272833c213cc6d49ed5214",
            },
        },
        opts = {
            pre_hook = function(ctx)
                if vim.bo.filetype == "typescriptreact" then
                    local U = require("Comment.utils")

                    local type = ctx.ctype == U.ctype.linewise and "__default" or "__multiline"

                    local location = nil
                    if ctx.ctype == U.ctype.blockwise then
                        location = require("ts_context_commentstring.utils").get_cursor_location()
                    elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
                        location = require("ts_context_commentstring.utils").get_visual_start_location()
                    end

                    return require("ts_context_commentstring.internal").calculate_commentstring({
                        key = type,
                        location = location,
                    })
                end
            end,
        },
    },
}
