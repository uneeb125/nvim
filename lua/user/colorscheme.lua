local M = {
  "folke/tokyonight.nvim",
  commit = "bbb3f9fb628dba2064e0a6ac0b7e77b10ea7c47f",
  lazy = false,    -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
}

M.name = "tokyonight-night"
function M.config()
  local status_ok, _ = pcall(vim.cmd.colorscheme, M.name)
  if not status_ok then
    return
  end
end

return M
