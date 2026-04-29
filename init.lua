vim.deprecate = function() end

-- Enable Neovim 0.12 experimental UI2 (vim._core.ui2)
require("vim._core.ui2").enable({})

require("config.lazy")
