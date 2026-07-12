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

                if filetype == "latex" or vim.startswith(filetype, "snacks_") or filetype == "fzf" then
                    return
                end

                local lang = vim.treesitter.language.get_lang(filetype)
                if not lang or vim.list_contains(treesitter.get_installed(), lang) then
                    pcall(vim.treesitter.start, bufnr)
                    vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                elseif require("nvim-treesitter.parsers")[lang] then
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
                    ["@conditional.outer"] = "V",
                    ["@loop.outer"] = "V",
                    ["@block.outer"] = "v",
                },
                include_surrounding_whitespace = true,
            },
        })

        local function sel(mode, keys, query, desc)
            vim.keymap.set(mode, keys, function()
                require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
            end, { desc = desc })
        end

        -- Text objects
        sel({ "x", "o" }, "af", "@function.outer", "Select outer function")
        sel({ "x", "o" }, "if", "@function.inner", "Select inner function")
        sel({ "x", "o" }, "ac", "@class.outer", "Select outer class")
        sel({ "x", "o" }, "ic", "@class.inner", "Select inner class")
        sel({ "x", "o" }, "ao", "@comment.outer", "Select outer comment")
        sel({ "x", "o" }, "as", "@local.scope", "Select language scope")
        sel({ "x", "o" }, "al", "@loop.outer", "Select outer loop")
        sel({ "x", "o" }, "il", "@loop.inner", "Select inner loop")
        sel({ "x", "o" }, "aC", "@conditional.outer", "Select outer conditional")
        sel({ "x", "o" }, "iC", "@conditional.inner", "Select inner conditional")
        sel({ "x", "o" }, "ab", "@block.outer", "Select outer block")
        sel({ "x", "o" }, "ib", "@block.inner", "Select inner block")
        sel({ "x", "o" }, "aR", "@return.outer", "Select outer return")
        sel({ "x", "o" }, "iR", "@return.inner", "Select inner return")
        sel({ "x", "o" }, "aA", "@assignment.outer", "Select outer assignment")
        sel({ "x", "o" }, "iA", "@assignment.inner", "Select inner assignment")
        sel({ "x", "o" }, "aP", "@call.outer", "Select outer function call")
        sel({ "x", "o" }, "iP", "@call.inner", "Select inner function call")
        sel({ "x", "o" }, "aN", "@number.inner", "Select number")
        sel({ "x", "o" }, "aB", "@branch.outer", "Select outer branch")
        sel({ "x", "o" }, "iB", "@branch.inner", "Select inner branch")

        -- Motions (jump between nodes)
        local function mv_next(k, query, desc)
            vim.keymap.set({ "n", "x", "o" }, k, function()
                require("nvim-treesitter-textobjects.move").goto_next_start(query, "textobjects")
            end, { desc = desc })
        end
        local function mv_prev(k, query, desc)
            vim.keymap.set({ "n", "x", "o" }, k, function()
                require("nvim-treesitter-textobjects.move").goto_previous_start(query, "textobjects")
            end, { desc = desc })
        end

        mv_next("]f", "@function.outer", "Next function")
        mv_prev("[f", "@function.outer", "Prev function")
        mv_next("]c", "@class.outer", "Next class")
        mv_prev("[c", "@class.outer", "Prev class")
        mv_next("]a", "@parameter.outer", "Next parameter")
        mv_prev("[a", "@parameter.outer", "Prev parameter")
        mv_next("]l", "@loop.outer", "Next loop")
        mv_prev("[l", "@loop.outer", "Prev loop")
        mv_next("]b", "@block.outer", "Next block")
        mv_prev("[b", "@block.outer", "Prev block")
        mv_next("]C", "@conditional.outer", "Next conditional")
        mv_prev("[C", "@conditional.outer", "Prev conditional")
        mv_next("]o", "@comment.outer", "Next comment")
        mv_prev("[o", "@comment.outer", "Prev comment")
        mv_next("]s", "@statement.outer", "Next statement")
        mv_prev("[s", "@statement.outer", "Prev statement")

        -- Swaps
        local function sw_n(k, query, desc)
            vim.keymap.set("n", k, function()
                require("nvim-treesitter-textobjects.swap").swap_next(query)
            end, { desc = desc })
        end
        local function sw_p(k, query, desc)
            vim.keymap.set("n", k, function()
                require("nvim-treesitter-textobjects.swap").swap_previous(query)
            end, { desc = desc })
        end

        sw_n("<leader>a", "@parameter.inner", "Swap next parameter")
        sw_p("<leader>A", "@parameter.inner", "Swap prev parameter")
        sw_n("<leader>sf", "@function.inner", "Swap next function")
        sw_p("<leader>sF", "@function.inner", "Swap prev function")
        sw_n("<leader>sc", "@class.inner", "Swap next class")
        sw_p("<leader>sC", "@class.inner", "Swap prev class")
        sw_n("<leader>sl", "@loop.inner", "Swap next loop")
        sw_p("<leader>sL", "@loop.inner", "Swap prev loop")
        sw_n("<leader>si", "@conditional.inner", "Swap next conditional")
        sw_p("<leader>sI", "@conditional.inner", "Swap prev conditional")
        sw_n("<leader>sb", "@block.inner", "Swap next block")
        sw_p("<leader>sB", "@block.inner", "Swap prev block")

        -- Incremental selection
        vim.keymap.set("n", "<Enter>", require("incselect").init, { desc = "Treesitter init selection" })
        vim.keymap.set({ "x", "v" }, "<Enter>", require("incselect").parent, { desc = "Treesitter expand selection" })
        vim.keymap.set({ "x", "v" }, "<Backspace>", require("incselect").child, { desc = "Treesitter shrink selection" })
    end,
}
