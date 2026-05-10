return {
  "jaswdr/opencode-completion.nvim",
  keys = {
    { "<A-y>", "<cmd>OpenCodeComplete<CR>", mode = { "n", "i" }, desc = "OpenCode AI Completion" },
  },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("opencode-completion").setup()
    -- Remove the hardcoded <C-l> mapping to avoid clobbering blink.cmp
    pcall(vim.keymap.del, "n", "<C-l>")
    pcall(vim.keymap.del, "i", "<C-l>")
  end,
}
