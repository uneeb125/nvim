return {
  'mrcjkb/rustaceanvim',
  version = '^9',
  lazy = false, -- Plugin handles its own lazy loading
  dependencies = {
    'mfussenegger/nvim-dap',
  },
  config = function()
    -- 1. DYNAMIC DEBUGGER SETUP (Mason codelldb)
    local codelldb_path, liblldb_path
    local mason_registry = require('mason-registry')
    local ok, codelldb = pcall(mason_registry.get_package, "codelldb")
    
    if ok and codelldb:is_installed() then
      local pkg_path = codelldb:get_install_path()
      local extension_path = pkg_path .. "/extension/"
      codelldb_path = extension_path .. "adapter/codelldb"
      liblldb_path = extension_path .. "lldb/lib/liblldb"
      local this_os = vim.uv.os_uname().sysname
      if this_os:find "Windows" then
        codelldb_path = extension_path .. "adapter\\codelldb.exe"
        liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
      else
        liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
      end
    end

    -- 2. SMART ROOT DETECTION
    -- Prevents lspmux from spawning multiple rust-analyzer instances for rustc sub-crates
    local function get_root_dir(startpath)
      local util = require('lspconfig.util')
      -- 1. Prioritize the Rust Compiler root (x.py)
      local rustc_root = util.root_pattern("x.py")(startpath)
      if rustc_root then return rustc_root end
      -- 2. Fallback to normal projects
      return util.root_pattern("Cargo.toml", ".git")(startpath)
    end

    -- 3. CONFIGURE RUSTACEANVIM
    -- Use a function so blink.cmp capabilities are resolved lazily
    -- (blink.cmp loads on InsertEnter, after this plugin loads at startup)
    vim.g.rustaceanvim = function()
      return {
        tools = {
          float_win_config = { border = 'rounded' },
          test_executor = 'background',
          hover_actions = { auto_focus = true },
          code_actions = { ui_select_fallback = true },
        },

        dap = {
          adapter = (codelldb_path and liblldb_path)
            and require('rustaceanvim.config').get_codelldb_adapter(codelldb_path, liblldb_path)
            or nil,
        },

        server = {
          capabilities = require('blink.cmp').get_lsp_capabilities(),
          cmd = { 'lspmux' },
          root_dir = get_root_dir,

          default_settings = {
            ['rust-analyzer'] = {
              cargo = { allFeatures = true },
              checkOnSave = false,
              procMacro = { enable = true },
              rustc = { source = "discover" },
              folding = { ranges = true },
              completion = {
                addCallParenthesis = true,
                addCallArgumentSnippets = true,
                fullFunctionSignatures = { enable = true },
                postfix = { enable = true },
                autoimport = { enable = true },
                autoself = { enable = true },
                callable = { snippets = "fill_arguments" },
              },
              assist = {
                importGranularity = "module",
                importPrefix = "self",
                emitMustUse = false,
              },
              lens = {
                enable = true,
                run = { enable = true },
                debug = { enable = true },
              },
              inlayHints = {
                enabled = true,
                typeHints = { enable = true },
                parameterHints = { enable = true },
                chainingHints = { enable = true },
                bindingModeHints = { enable = true },
                closingBraceHints = { enable = true },
              },
            },
          },

          on_attach = function(client, bufnr)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc, silent = true })
          end

          client.server_capabilities.semanticTokensProvider = nil

          -- STANDARD NAVIGATION
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
          map("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
          map("gI", function()
            local f_ok, fzf = pcall(require, "fzf-lua")
            if f_ok then fzf.lsp_implementations() else vim.lsp.buf.implementation() end
          end, "Fzf Implementations")

          -- COMPILER DEV POWER TOOLS
          map("go", function() vim.cmd.RustLsp({ 'hover', 'actions' }) end, "Hover Actions")
          map("<leader>ra", function() vim.cmd.RustLsp('codeAction') end, "Code Actions")
          map("<leader>rh", function() vim.cmd.RustLsp({ 'view', 'hir' }) end, "View HIR")
          map("<leader>rm", function() vim.cmd.RustLsp({ 'view', 'mir' }) end, "View MIR")
          map("<leader>rs", function() vim.cmd.RustLsp('ssr') end, "Structural Search Replace")
          map("<leader>lc", function() vim.cmd.RustLsp('flyCheck') end, "Manual FlyCheck")
          map("<leader>re", function() vim.cmd.RustLsp({ 'renderDiagnostic', 'current' }) end, "Render Full Error")
          map("<leader>rd", function() vim.cmd.RustLsp('relatedDiagnostics') end, "Related Diagnostics")
          map("<leader>rp", function() vim.cmd.RustLsp('parentModule') end, "Parent Module")
          map("<leader>re", function() require('rustaceanvim.commands.expand_macro')() end, "Expand Macro")
          
          -- RUN / DEBUG
          map("<leader>rr", function() vim.cmd.RustLsp('runnables') end, "Runnables")
          map("<leader>rd", function() vim.cmd.RustLsp('debuggables') end, "Debuggables")
          map("<leader>rt", function() vim.cmd.RustLsp('testables') end, "Testables")
          
          -- MISC
          map("<leader>rk", vim.lsp.buf.hover, "LSP Hover")
          map("<leader>rc", function() vim.cmd.RustLsp('openCargo') end, "Open Cargo.toml")
          map("<leader>cr", vim.lsp.buf.rename, "Rename")
          map("<leader>j", function() vim.cmd.RustLsp('joinLines') end, "Smart Join Lines")
        end,
      },
    }
    end
  end
}
