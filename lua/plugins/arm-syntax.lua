return {
    "ARM9/arm-syntax-vim",
    init = function()
        vim.cmd([[ au VimEnter,BufReadPost *.[sS] setl filetype=arm ]])
    end,
}
