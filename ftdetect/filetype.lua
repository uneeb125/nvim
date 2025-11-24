vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.ast",
  command = "set filetype=ast",
})
