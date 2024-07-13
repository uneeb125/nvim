local M = {
  "nvim-treesitter/nvim-treesitter",
  commit = "fc7657a071ad7be0616d7c66a74991a3c1b1dbcd",
  event = "BufReadPost",
  dependencies = {
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      event = "VeryLazy",
      commit = "f1905136b99b5d706858d4c9274a3b152b4359ed",
    },
    {
      "nvim-tree/nvim-web-devicons",
      event = "VeryLazy",
    },
  },
}
function M.config()
  local treesitter = require "nvim-treesitter"
  local configs = require "nvim-treesitter.configs"

  configs.setup {}
  --   ensure_installed = { "lua", "markdown", "markdown_inline", "bash", "python" }, -- put the language you want in this array
  --   -- ensure_installed = "all", -- one of "all" or a list of languages
  --   ignore_install = { "" },                                                       -- List of parsers to ignore installing
  --   sync_install = false,                                                          -- install languages synchronously (only applied to `ensure_installed`)
  --
  --   highlight = {
  --     enable = true,       -- false will disable the whole extension
  --     disable = { "css" }, -- list of language that will be disabled
  --   },
  --   autopairs = {
  --     enable = true,
  --   },
  --   indent = { enable = true, disable = { "python", "css" } },
  --
  --   context_commentstring = {
  --     enable = true,
  --     enable_autocmd = false,
  --   },
  -- }
end

return M
