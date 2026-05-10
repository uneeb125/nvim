return {
  "Canop/nvim-bacon",
  config = function()
    require("bacon").setup({
      quickfix = {
        enabled = true,
        event_trigger = true,
      },
    })

    vim.keymap.set("n", "<leader>rb", function() vim.cmd.BaconList() end, { desc = "Bacon: Toggle Locations" })
  end,
}
