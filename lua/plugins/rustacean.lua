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
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          local map = function(modes, keys, func, desc)
            vim.keymap.set(modes, keys, func, { buffer = bufnr, desc = desc, silent = true })
          end

          -- STANDARD NAVIGATION
          map("n", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
          map("n", "gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
          map("n", "gI", function()
            local f_ok, fzf = pcall(require, "fzf-lua")
            if f_ok then fzf.lsp_implementations() else vim.lsp.buf.implementation() end
          end, "Fzf Implementations")

          -- COMPILER DEV POWER TOOLS
          map("n", "go", function() vim.cmd.RustLsp({ 'hover', 'actions' }) end, "Hover Actions")
          local code_action_group = require('rustaceanvim.commands.code_action_group')
          map({ "n", "v" }, "<leader>ra", function()
            local mode = vim.fn.mode()
            local is_visual = mode == 'v' or mode == 'V' or mode:byte() == 22
            if is_visual then
              code_action_group.code_action_group_visual()
            else
              code_action_group.code_action_group()
            end
          end, "Code Actions")
          map("n", "<leader>rh", function() vim.cmd.RustLsp({ 'view', 'hir' }) end, "View HIR")
          map("n", "<leader>rm", function() vim.cmd.RustLsp({ 'view', 'mir' }) end, "View MIR")
          map({ "n", "v" }, "<leader>rs", function() vim.cmd.RustLsp('ssr') end, "Structural Search Replace")
          map("n", "<leader>lc", function() vim.cmd.RustLsp('flyCheck') end, "Manual FlyCheck")
          map("n", "<leader>re", function() vim.cmd.RustLsp({ 'renderDiagnostic', 'current' }) end, "Render Full Error")
          map("n", "<leader>rd", function() vim.cmd.RustLsp('relatedDiagnostics') end, "Related Diagnostics")
          map("n", "<leader>rp", function() vim.cmd.RustLsp('parentModule') end, "Parent Module")
          map("n", "<leader>rme", function() require('rustaceanvim.commands.expand_macro')() end, "Expand Macro")

          -- RUN / DEBUG
          map("n", "<leader>rr", function() vim.cmd.RustLsp('runnables') end, "Runnables")
          map("n", "<leader>rd", function() vim.cmd.RustLsp('debuggables') end, "Debuggables")
          map("n", "<leader>rt", function() vim.cmd.RustLsp('testables') end, "Testables")

          vim.b.rustaceanvim_check_on_save = false
          map("n", "<leader>rj", function()
            local new_state = not vim.b.rustaceanvim_check_on_save
            vim.b.rustaceanvim_check_on_save = new_state
            client.notify('workspace/didChangeConfiguration', {
              settings = { ['rust-analyzer'] = { checkOnSave = new_state } },
            })
            vim.notify(string.format('Rust checkOnSave: %s', new_state and 'ENABLED' or 'DISABLED'))
          end, "Toggle Check on Save [J]")
          map("n", "<leader>rl", function() vim.cmd('w') vim.cmd.RustLsp('flyCheck') end, "Run FlyCheck Now [L]")

          -- MISC
          map("n", "<leader>rk", vim.lsp.buf.hover, "LSP Hover")
          map("n", "<leader>rc", function() vim.cmd.RustLsp('openCargo') end, "Open Cargo.toml")
          map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
          map({ "n", "v" }, "<leader>j", function() vim.cmd.RustLsp('joinLines') end, "Smart Join Lines")
        end,
      },
    }
    end
  end
}
