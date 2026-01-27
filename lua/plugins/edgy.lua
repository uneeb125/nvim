return {
    "folke/edgy.nvim",
    event = "VeryLazy",
    init = function()
        vim.opt.laststatus = 3
        vim.opt.splitkeep = "screen"
    end,
    opts = {
        left = {},
        bottom = {},
        right = {},
        top = {},
        options = {
            left = { size = 30 },
            bottom = { size = 10 },
            right = { size = 30 },
            top = { size = 10 },
        },
        animate = {
            enabled = true,
            fps = 30,
            cps = 60,
            on_begin = function()
                vim.g.minianimate_disable = true
            end,
            on_end = function()
                vim.g.minianimate_disable = false
            end,
            spinner = {
                frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
                interval = 80,
            },
        },
        exit_when_last = false,
        close_when_all_hidden = true,
        wo = {
            winbar = true,
            winfixwidth = true,
            winfixheight = false,
            winhighlight = "WinBar:EdgyWinBar,Normal:EdgyNormal",
            spell = false,
            signcolumn = "no",
        },
        keys = {
            ["q"] = function(win)
                win:close()
            end,
            ["<c-q>"] = function(win)
                win:hide()
            end,
            ["Q"] = function(win)
                win.view.edgebar:close()
            end,
            ["]w"] = function(win)
                win:next({ visible = true, focus = true })
            end,
            ["[w"] = function(win)
                win:prev({ visible = true, focus = true })
            end,
            ["]W"] = function(win)
                win:next({ pinned = false, focus = true })
            end,
            ["[W"] = function(win)
                win:prev({ pinned = false, focus = true })
            end,
            ["<c-w>>"] = function(win)
                win:resize("width", 2)
            end,
            ["<c-w><lt>"] = function(win)
                win:resize("width", -2)
            end,
            ["<c-w>+"] = function(win)
                win:resize("height", 2)
            end,
            ["<c-w>-"] = function(win)
                win:resize("height", -2)
            end,
            ["<c-w>="] = function(win)
                win.view.edgebar:equalize()
            end,
        },
        icons = {
            closed = " ",
            open = " ",
        },
        fix_win_height = vim.fn.has("nvim-0.10.0") == 0,
    },
}
