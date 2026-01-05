return {
  'mrcjkb/rustaceanvim',
  version = '^6',
  lazy = false,
  dependencies = {
    'mfussenegger/nvim-dap',
    {
      'nvim-treesitter/nvim-treesitter',
      opts = { ensure_installed = { 'rust' } },
    },
  },
  config = function()
    -- 1. PREPARE DEBUGGER ADAPTER (codelldb)
    local mason_registry = require('mason-registry')
    local codelldb = mason_registry.get_package("codelldb")
    -- local extension_path = codelldb:get_install_path() .. "/extension/"
    -- local codelldb_path = extension_path .. "adapter/codelldb"
    -- local liblldb_path = extension_path .. "lldb/lib/liblldb"
    -- 
    -- local this_os = vim.uv.os_uname().sysname
    -- if this_os:find "Windows" then
    --   codelldb_path = extension_path .. "adapter\\codelldb.exe"
    --   liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
    -- else
    --   liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
    -- end

    local cfg = require('rustaceanvim.config')

    -- 2. CONFIGURE RUSTACEANVIM
    vim.g.rustaceanvim = {
      tools = {
        float_win_config = {
          border = 'rounded',
        },
      },
      
      -- dap = {
      --   adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
      -- },

      server = {
        -- Connect to systemd lspmux service
        cmd = { 'lspmux' },
        
        default_settings = {
          ['rust-analyzer'] = {
            cargo = { allFeatures = true },
            checkOnSave = false,
            procMacro = { enable = true},
              -- enable = true,  -- Keep enabled so it tries (even if it fails silently)
              -- ignored = {
              --   ["*"] = { "*" }, 
              -- },
            rustc = {
              source = "discover",
            },
          },
        },
        
        -- 3. KEYMAPPINGS
        on_attach = function(client, bufnr)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc, silent = true })
          end

          -- Navigation
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
          map("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation") -- Added this

          -- CHANGED: Use fzf-lua for implementations
          map("gI", function()
            local ok, fzf = pcall(require, "fzf-lua")
            if ok then
              -- This handles multiple results by opening the fzf window,
              -- and jumps immediately if there is only one result.
              fzf.lsp_implementations() 
            else
              vim.lsp.buf.implementation()
            end
          end, "[G]oto [I]mplementation")

          map("gk", function() vim.cmd.RustLsp({ "hover", "actions" }) end, "Hover Actions")

          -- Rustacean specific actions
          map("<leader>ra", function() vim.cmd.RustLsp("codeAction") end, "[R]ust [A]ction")
          map("<leader>rr", function() vim.cmd.RustLsp("runnables") end, "[R]ust [R]unnables")
          map("<leader>rt", function() vim.cmd.RustLsp("testables") end, "[R]ust [T]estables")
          map("<leader>rd", function() vim.cmd.RustLsp("openDocs") end, "[R]ust [D]ocs")
          map("<leader>re", function() vim.cmd.RustLsp("expandMacro") end, "[R]ust [E]xpand Macro")
          map("<leader>rc", function() vim.cmd.RustLsp("openCargo") end, "[R]ust [C]argo.toml")
          
          -- Standard LSP helpers
          map("<leader>cr", vim.lsp.buf.rename, "[C]ode [R]ename")
          map("<leader>rs", vim.lsp.buf.signature_help, "[R]ust [S]ignature Help")
        end,
      },
    }
  end
}
