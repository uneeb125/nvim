return {
  'mrcjkb/rustaceanvim',
  version = '^5',
  lazy = true, -- Enable lazy loading
  ft = {}, -- Important: Set this to empty so it DOES NOT load on 'rust' filetype automatically
  
  -- The init function runs on startup (before the plugin loads). 
  -- We use it to create your command.
  init = function()
    vim.api.nvim_create_user_command('RustAnalyzer', function(opts)
      if opts.args == "start" then
        -- 1. Load the plugin
        require('lazy').load({ plugins = { "rustaceanvim" } })
        
        -- 2. Rustaceanvim attaches via FileType events. 
        -- Since the file is already open, we must re-trigger the event manually.
        if vim.bo.filetype == 'rust' then
          vim.cmd('doautocmd FileType rust')
          print("Rust-Analyzer started.")
        else
          print("Not a Rust file.")
        end
      else
        print("Usage: :RustAnalyzer start")
      end
    end, { 
      nargs = 1, 
      complete = function() return { "start" } end 
    })
  end,

  config = function()
    vim.g.rustaceanvim = {
      -- Standard configuration goes here
      server = {
        -- You don't need 'autostart = false' here anymore
      },
    }
  end,
}
