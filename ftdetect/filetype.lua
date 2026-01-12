vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.ast",
  command = "set filetype=ast",
})

vim.filetype.add({
  extension = {
    service = "systemd",
    tpl = "smarty",
  },
})
