return {
    "lervag/vimtex",
    lazy = false,
    init = function()
        vim.g.vimtex_view_method = "zathura"
        vim.g.maplocalleader = ","
        vim.g.vimtex_view_autofocus = 0
    end,
    config = function()
        vim.o.foldmethod = "expr"
        vim.o.foldexpr = "vimtex#fold#level(v:lnum)"
        vim.o.foldtext = "vimtex#fold#text()"
        vim.o.foldlevel = 2
    end,
}
