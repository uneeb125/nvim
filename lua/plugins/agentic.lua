return {
  "carlos-algms/agentic.nvim",

  --- @type agentic.PartialUserConfig
  opts = {
    -- Any ACP-compatible provider works. Built-in: "claude-agent-acp" | "gemini-acp" | "codex-acp" | "opencode-acp" | "cursor-acp" | "copilot-acp" | "auggie-acp" | "mistral-vibe-acp" | "cline-acp" | "goose-acp" | "kiro-acp" | "pi-acp"
    provider = "opencode-acp", -- setting the name here is all you need to get started

    folding = {
      tool_calls = {
        enabled = true,
        threshold = 0,         -- always fold completed tool calls (includes think blocks)
        fold_on_error = false, -- keep failed tool calls unfolded for inspection
      },
    },

    tool_calls = {
      title = {
        max_length = 50,
        truncate_title_kinds = { "execute", "think", "SubAgent", "fetch", "search" },
      },
    },
  },

  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "AgenticChat",
      callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        vim.keymap.set("n", "<leader>oe", function()
          local ToolCallBlocks = require("agentic.ui.tool_call_blocks")
          local cursor = vim.api.nvim_win_get_cursor(0)
          local row = cursor[1] - 1 -- 0-indexed

          local block_range = ToolCallBlocks.block_range_at_row(bufnr, row)
          if not block_range then
            vim.notify("No tool call block at cursor", vim.log.levels.WARN)
            return
          end

          local header = vim.api.nvim_buf_get_lines(
            bufnr,
            block_range.start_row,
            block_range.start_row + 1,
            false
          )[1]
          if not header then
            return
          end

          -- Parse " kind(path) " -> extract path inside parentheses
          local path = header:match("%((.+)%)")
          if not path then
            vim.notify("No file path found in tool call header", vim.log.levels.WARN)
            return
          end
          path = vim.trim(path)

          -- Resolve path: try multiple candidates to handle relative/absolute variants
          local candidates = {
            path,                                    -- as-is (may be absolute)
            "/" .. path,                             -- prepend leading slash
            vim.fn.getcwd() .. "/" .. path,          -- relative to cwd
          }

          -- Try git root as well
          local ok_git, git_root = pcall(vim.fn.systemlist, { "git", "rev-parse", "--show-toplevel" })
          if ok_git and git_root and #git_root > 0 then
            table.insert(candidates, git_root[1] .. "/" .. path)
          end

          local found
          for _, candidate in ipairs(candidates) do
            local resolved = vim.fn.fnamemodify(candidate, ":p")
            if vim.fn.filereadable(resolved) == 1 then
              found = resolved
              break
            end
          end

          if not found then
            vim.notify("File not found: " .. path, vim.log.levels.WARN)
            return
          end

          vim.cmd("edit " .. vim.fn.fnameescape(found))
        end, { buffer = bufnr, desc = "[O]pen Agentic: Open [E]dited file" })
      end,
    })
  end,

  -- these are just suggested keymaps; customize as desired
  keys = {
    {
      "<leader>oa", -- oa = Open Agentic
      function() require("agentic").toggle() end,
      mode = { "n", "v", "i" },
      desc = "[O]pen [A]gentic (toggle)",
    },
    {
      "<leader>oc", -- oc = context
      function() require("agentic").add_selection_or_file_to_context() end,
      mode = { "n", "v" },
      desc = "[O]pen Agentic: Add to [C]ontext",
    },
    {
      "<leader>on", -- on = new
      function() require("agentic").new_session() end,
      mode = { "n", "v", "i" },
      desc = "[O]pen Agentic: [N]ew session",
    },
    {
      "<leader>or", -- or = restore
      function() require("agentic").restore_session() end,
      mode = { "n", "v", "i" },
      desc = "[O]pen Agentic: [R]estore session",
    },
    {
      "<leader>od", -- od = diagnostics
      function() require("agentic").add_current_line_diagnostics() end,
      mode = { "n" },
      desc = "[O]pen Agentic: Current line [D]iagnostics",
    },
    {
      "<leader>oD", -- oD = all diagnostics
      function() require("agentic").add_buffer_diagnostics() end,
      mode = { "n" },
      desc = "[O]pen Agentic: All buffer [D]iagnostics",
    },
  },
}
