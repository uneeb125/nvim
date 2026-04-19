return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    event = "VeryLazy",
    dependencies = {
        {
            "nvim-treesitter/nvim-treesitter-textobjects",
            branch = "main",
            init = function()
                vim.g.no_plugin_maps = true
            end,
        },
        "shushtain/incselect.nvim",
    },
    config = function()
        local treesitter = require("nvim-treesitter")

        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                local bufnr = args.buf
                local filetype = vim.bo[bufnr].filetype

                if filetype == "latex" then
                    return
                end

                local lang = vim.treesitter.language.get_lang(filetype)
                if not lang or vim.list_contains(treesitter.get_installed(), lang) then
                    pcall(vim.treesitter.start, bufnr)
                    vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                else
                    treesitter.install({ lang })
                end
            end,
        })

        require("nvim-treesitter-textobjects").setup({
            select = {
                lookahead = true,
                selection_modes = {
                    ["@parameter.outer"] = "v",
                    ["@function.outer"] = "V",
                    ["@class.outer"] = "<c-v>",
                },
                include_surrounding_whitespace = true,
            },
        })

        vim.keymap.set({ "x", "o" }, "af", function()
            require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
        end, { desc = "Select outer function" })

        vim.keymap.set({ "x", "o" }, "if", function()
            require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
        end, { desc = "Select inner function" })

        vim.keymap.set({ "x", "o" }, "ac", function()
            require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
        end, { desc = "Select outer class" })

        vim.keymap.set({ "x", "o" }, "ic", function()
            require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
        end, { desc = "Select inner class" })

        vim.keymap.set({ "x", "o" }, "ao", function()
            require("nvim-treesitter-textobjects.select").select_textobject("@comment.outer", "textobjects")
        end, { desc = "Select outer comment" })

        vim.keymap.set({ "x", "o" }, "as", function()
            require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
        end, { desc = "Select language scope" })

        vim.keymap.set("n", "<leader>a", function()
            require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
        end, { desc = "Swap with next parameter" })

        vim.keymap.set("n", "<leader>A", function()
            require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
        end, { desc = "Swap with previous parameter" })

        vim.keymap.set("n", "<Enter>", require("incselect").init, { desc = "Treesitter init selection" })
        vim.keymap.set({ "x", "v" }, "<Enter>", require("incselect").parent, { desc = "Treesitter expand selection" })
        vim.keymap.set({ "x", "v" }, "<Backspace>", require("incselect").child, { desc = "Treesitter shrink selection" })
    end,
}
