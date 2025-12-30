return {
  "L3MON4D3/LuaSnip",
  version = "2.*",
  event = "InsertEnter",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  config = function()
    local ls = require("luasnip")

    ls.config.set_config({
      history = true,
      update_events = "TextChanged,TextChangedI",
      enable_autosnippets = true,
      region_check_events = "CursorMoved,CursorMovedI,TextChanged,TextChangedI",
      delete_check_events = "InsertLeave",
    })

    -- Load friendly-snippets
    require("luasnip.loaders.from_vscode").lazy_load()

    -- Load custom Lua snippets from lua/snippets
    local snippets_path = vim.fn.stdpath("config") .. "/lua/snippets"
    pcall(function()
      require("luasnip.loaders.from_lua").load({ paths = snippets_path })
    end)

    -- Helper function to check if we can safely expand/jump
    local function can_use_snippets()
      return vim.bo.buftype == "" and vim.bo.modifiable and not vim.bo.readonly
    end

    -- Keymaps
    vim.keymap.set({ "n", "s" }, "<Tab>", function()
      -- If completion menu is visible, let blink.cmp handle it
      if vim.fn.pumvisible() == 1 then
        return "<Tab>"
      end
      
      if not can_use_snippets() then
        return "<Tab>"
      end
      
      -- Try to expand or jump forward
      local ok, jumpable = pcall(function()
        return ls.expand_or_jumpable()
      end)
      
      if ok and jumpable then
        local success = pcall(function()
          ls.expand_or_jump()
        end)
        if success then
          return ""
        end
      end
      
      -- Not expandable or jumpable
      return "<Tab>"
    end, { expr = true })

    vim.keymap.set({ "n", "s" }, "<S-Tab>", function()
      -- If completion menu is visible, let blink.cmp handle navigation
      if vim.fn.pumvisible() == 1 then
        return "<S-Tab>"
      end
      
      if not can_use_snippets() then
        return "<S-Tab>"
      end
      
      local ok, jumped = pcall(function()
        if ls.jumpable(-1) then
          ls.jump(-1)
          return true
        end
        return false
      end)
      
      if ok and jumped then
        return
      end
      
      return "<S-Tab>"
    end, { expr = true, silent = true })

    vim.keymap.set({ "i", "s" }, "<C-E>", function()
      if can_use_snippets() and ls.choice_active() then
        pcall(function() ls.change_choice(1) end)
      end
    end, { silent = true })
  end,
}
