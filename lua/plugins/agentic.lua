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
