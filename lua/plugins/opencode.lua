return {
  "sudo-tee/opencode.nvim", -- CHANGED: Pointing to the correct repository for this config!
  dependencies = {
    { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  },
  -- 'opts' is the lazy.nvim standard way to pass options to the setup() function
  opts = {
    preferred_picker = "fzf", 
    preferred_completion = "blink", 
    default_global_keymaps = true, 
    default_mode = 'build', 
    default_system_prompt = nil, 
    keymap_prefix = '<leader>o', 
    opencode_executable = 'opencode', 

    -- Server configuration for custom/external opencode servers
    server = {
      url = nil,             
      port = nil,            
      timeout = 5,           
      spawn_command = nil,   
      auto_kill = true,      
      path_map = nil,        
    },

    keymap = {
      editor = {
        ['<leader>og'] = { 'toggle' }, 
        ['<leader>oi'] = { 'open_input' },['<leader>oI'] = { 'open_input_new_session' },['<leader>oo'] = { 'open_output' }, 
        ['<leader>ot'] = { 'toggle_focus' }, 
        ['<leader>oT'] = { 'timeline' },['<leader>oq'] = { 'close' }, 
        ['<leader>os'] = { 'select_session' }, 
        ['<leader>oR'] = { 'rename_session' }, 
        ['<leader>op'] = { 'configure_provider' }, 
        ['<leader>oV'] = { 'configure_variant' }, 
        ['<leader>oy'] = { 'add_visual_selection', mode = {'v'} },
        ['<leader>oY'] = { 'add_visual_selection_inline', mode = {'v'} }, 
        ['<leader>oz'] = { 'toggle_zoom' }, 
        ['<leader>ov'] = { 'paste_image'},['<leader>od'] = { 'diff_open' }, 
        ['<leader>o]'] = { 'diff_next' }, 
        ['<leader>o['] = { 'diff_prev' }, 
        ['<leader>oc'] = { 'diff_close' },['<leader>ora'] = { 'diff_revert_all_last_prompt' },['<leader>ort'] = { 'diff_revert_this_last_prompt' },['<leader>orA'] = { 'diff_revert_all' }, 
        ['<leader>orT'] = { 'diff_revert_this' }, 
        ['<leader>orr'] = { 'diff_restore_snapshot_file' }, 
        ['<leader>orR'] = { 'diff_restore_snapshot_all' }, 
        ['<leader>ox'] = { 'swap_position' }, 
        ['<leader>ott'] = { 'toggle_tool_output' },['<leader>otr'] = { 'toggle_reasoning_output' }, 
        ['<leader>o/'] = { 'quick_chat', mode = { 'n', 'x' } }, 
      },
      input_window = {
        ['<S-cr>'] = { 'submit_input_prompt', mode = { 'n', 'i' } }, 
        ['<esc>'] = { 'close', defer_to_completion = true }, 
        ['<C-c>'] = { 'cancel', defer_to_completion = true }, 
        ['~'] = { 'mention_file', mode = 'i' }, 
        ['@'] = { 'mention', mode = 'i' }, 
        ['/'] = { 'slash_commands', mode = 'i' }, 
        ['#'] = { 'context_items', mode = 'i' }, 
        ['<M-v>'] = { 'paste_image', mode = 'i' }, 
        ['<tab>'] = { 'toggle_pane', mode = { 'n', 'i' }, defer_to_completion = true }, 
        ['<up>'] = { 'prev_prompt_history', mode = { 'n', 'i' }, defer_to_completion = true }, 
        ['<down>'] = { 'next_prompt_history', mode = { 'n', 'i' }, defer_to_completion = true }, 
        ['<M-m>'] = { 'switch_mode' }, 
        ['<M-r>'] = { 'cycle_variant', mode = { 'n', 'i' } }, 
      },
      output_window = {
        ['<esc>'] = { 'close' }, 
        ['<C-c>'] = { 'cancel' }, 
        [']]'] = { 'next_message' }, 
        ['[['] = { 'prev_message' }, 
        ['<tab>'] = { 'toggle_pane', mode = { 'n', 'i' } }, 
        ['i'] = { 'focus_input', 'n' }, 
        ['<M-r>'] = { 'cycle_variant', mode = { 'n' } }, 
        ['<leader>oS'] = { 'select_child_session' }, 
        ['<leader>oD'] = { 'debug_message' },['<leader>oO'] = { 'debug_output' }, 
        ['<leader>ods'] = { 'debug_session' }, 
      },
      session_picker = {
        rename_session = { '<C-r>' }, 
        delete_session = { '<C-d>' }, 
        new_session = { '<C-s>' }, 
      },
      timeline_picker = {
        undo = { '<C-u>', mode = { 'i', 'n' } }, 
        fork = { '<C-f>', mode = { 'i', 'n' } }, 
      },
      history_picker = {
        delete_entry = { '<C-d>', mode = { 'i', 'n' } }, 
        clear_all = { '<C-X>', mode = { 'i', 'n' } }, 
      },
      model_picker = {
        toggle_favorite = { '<C-f>', mode = { 'i', 'n' } },
      },
      mcp_picker = {
        toggle_connection = { '<C-t>', mode = { 'i', 'n' } }, 
      },
    },
    ui = {
      enable_treesitter_markdown = true, 
      position = 'right', 
      input_position = 'bottom', 
      window_width = 0.40, 
      zoom_width = 0.8, 
      display_model = true, 
      display_context_size = true, 
      display_cost = true, 
      window_highlight = 'Normal:OpencodeBackground,FloatBorder:OpencodeBorder', 
      persist_state = true, 
      icons = {
        preset = 'nerdfonts', 
        overrides = {}, 
      },
      questions = {
        use_vim_ui_select = false, 
      },
      output = {
        filetype = 'opencode_output', 
        tools = {
          show_output = true, 
          show_reasoning_output = true, 
        },
        rendering = {
          markdown_debounce_ms = 250, 
          on_data_rendered = nil, 
        },
      },
      input = {
        min_height = 0.10, 
        max_height = 0.25, 
        text = {
          wrap = false, 
        },
        auto_hide = false,
      },
      picker = {
        snacks_layout = nil 
      },
      completion = {
        file_sources = {
          enabled = true,
          preferred_cli_tool = 'server', 
          ignore_patterns = {
            '^%.git/', '^%.svn/', '^%.hg/', 'node_modules/', '%.pyc$', '%.o$',
            '%.obj$', '%.exe$', '%.dll$', '%.so$', '%.dylib$', '%.class$',
            '%.jar$', '%.war$', '%.ear$', 'target/', 'build/', 'dist/',
            'out/', 'deps/', '%.tmp$', '%.temp$', '%.log$', '%.cache$',
          },
          max_files = 10,
          max_display_length = 50, 
        },
      },
    },
    context = {
      enabled = true, 
      cursor_data = {
        enabled = false, 
        context_lines = 5, 
      },
      diagnostics = {
        info = false, 
        warning = true, 
        error = true, 
        only_closest = false, 
      },
      current_file = {
        enabled = true, 
        show_full_path = true,
      },
      files = {
        enabled = true,
        show_full_path = true,
      },
      selection = {
        enabled = true, 
      },
      buffer = {
        enabled = false, 
      },
      git_diff = {
        enabled = false,
      },
    },
    logging = {
      enabled = false,
      level = 'warn', 
      outfile = nil,
    },
    debug = {
      enabled = false, 
      capture_streamed_events = false,
      show_ids = true,
      quick_chat = {
        keep_session = false, 
        set_active_session = false,
      },
    },
    prompt_guard = nil, 

    hooks = {
      on_file_edited = nil, 
      on_session_loaded = nil, 
      on_done_thinking = nil, 
      on_permission_requested = nil, 
    },
    quick_chat = {
      default_model = nil,   
      default_agent = nil, 
      instructions = nil, 
    },
  },
  
  config = function(_, opts)
    vim.o.autoread = true

    -- This setup function belongs to sudo-tee/opencode.nvim and will now run successfully!
    require("opencode").setup(opts)
  end,
}
