return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
      signs = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 500,
        virt_text_pos = 'eol',
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        map('n', ']h', function() gs.nav_hunk('next') end, "Next Hunk")
        map('n', '[h', function() gs.nav_hunk('prev') end, "Prev Hunk")

        map('n', '<leader>ghp', gs.preview_hunk, "Preview Hunk")
        map('n', '<leader>ghs', ":Gitsigns StageHunk<CR>", "Stage Hunk")
        map('n', '<leader>ghr', ":Gitsigns ResetHunk<CR>", "Reset Hunk")
        map('n', '<leader>ghS', gs.stage_buffer, "Stage Buffer")
        map('n', '<leader>ghu', gs.undo_stage_hunk, "Undo Stage Hunk")
        map('n', '<leader>ghR', gs.reset_buffer, "Reset Buffer")
        map('n', '<leader>ghd', gs.diffthis, "Diff This Hunk")
        map('n', '<leader>ghD', function() gs.diffthis('~') end, "Diff This ~")
        map('n', '<leader>ght', gs.toggle_deleted, "Toggle Deleted")
        map({ 'o', 'x' }, 'igh', ':<C-U>GitsignsSelectHunk<CR>', "Select Hunk")
      end
    }
  },

  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff Project" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Project History" },
    },
    opts = {
      enhanced_diff_hl = true,
      hooks = {
        diff_buf_read = function(bufnr)
          vim.opt_local.wrap = false
          vim.opt_local.list = false
        end,
      },
    }
  },

  {
    "tpope/vim-fugitive",
    keys = {
      { "<leader>gs", "<cmd>Git<cr>", desc = "Git Status" },
      { "<leader>gc", "<cmd>Git commit<CR>", desc = "Git Commit" },
      { "<leader>gb", "<cmd>Git blame<CR>", desc = "Git Blame" },
    }
  },

  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
      { "<leader>gf", "<cmd>LazyGit currentFile<cr>", desc = "LazyGit Current File" },
    }
  },

  {
    "FabijanZulj/blame.nvim",
    lazy = false,
    config = function()
      require("blame").setup({
        blame_options = { "-w" },
      })
    end,
  }
}
