local M = {
  "folke/which-key.nvim",
  commit = "b695114ddb251185625f61317317a39b67e80643",
  event = "VeryLazy",
}

function M.config()
  require("which-key").setup {}
end

return M
