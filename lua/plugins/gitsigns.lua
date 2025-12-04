return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre",
  opts = {
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        vim.keymap.set(mode, l, r, { buffer = bufnr, remap = false, silent = true, noremap = true, desc = opts.desc })
      end

      -- Navigation
      map({ "n", "v" }, "]g", function()
        if vim.wo.diff then
          return
        end
        vim.schedule(function()
          gs.next_hunk()
        end)
        return "<Ignore>"
      end, { desc = "Next Hunk" })

      map({ "n", "v" }, "[g", function()
        if vim.wo.diff then
          return
        end
        vim.schedule(function()
          gs.prev_hunk()
        end)
        return "<Ignore>"
      end, { desc = "Prev Hunk" })

      -- Actions
      map({ "n", "v" }, "<leader>gs", ":Gitsigns StageHunk<CR>", { desc = "Stage Hunk" })
      map({ "n", "v" }, "<leader>gr", ":Gitsigns ResetHunk<CR>", { desc = "Reset Hunk" })
      map("n", "<leader>gS", gs.stage_buffer, { desc = "Stage Buffer" })
      map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
      map("n", "<leader>gR", gs.reset_buffer, { desc = "Reset Buffer" })
      map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview Hunk" })
      map("n", "<leader>gb", function()
        gs.blame_line({ full = true })
      end, { desc = "Blame Line" })
      map("n", "<leader>gd", gs.diffthis, { desc = "Diff This" })
      map("n", "<leader>gD", function()
        gs.diffthis("~")
      end, { desc = "Diff This ~" })
      map({ "n", "v" }, "<leader>gt", gs.toggle_deleted, { desc = "Toggle Deleted" })

      -- Text object
      map({ "o", "x" }, "ig", ":<C-U>GitsignsSelectHunk<CR>", { desc = "Select Hunk" })
    end,
  },
}
