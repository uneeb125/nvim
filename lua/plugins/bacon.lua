return {
  "Canop/nvim-bacon",
  config = function()
    require("bacon").setup({
      quickfix = {
        enabled = true,
        event_trigger = true,
      },
    })

    local Terminal = require("toggleterm.terminal").Terminal
    local bacon_term = Terminal:new({ cmd = "bacon test", direction = "horizontal", hidden = true })
    vim.keymap.set("n", "<leader>rb", function()
      bacon_term:toggle()
    end, { desc = "Bacon: Toggle Terminal" })
  end,
}
