return {
  'mrjones2014/codesettings.nvim',
  opts = {
    -- 1. Look for these config files
    config_file_paths = { ".vscode/settings.json", "codesettings.json", "lspsettings.json" },
    
    jsonc_filetype = true,
    jsonls_integration = true,
    live_reload = false,
    
    -- 2. 👇 THIS IS THE FIX 👇
    -- We define a custom extension that finds "${workspaceFolder}" 
    -- and replaces it with the actual current working directory.
    loader_extensions = {
      {
        leaf = function(value)
          -- Check if the value is a string containing the variable
          if type(value) == 'string' and value:find('%${workspaceFolder}') then
            -- Replace it with the real path (vim.fn.getcwd())
            local expanded = value:gsub('%${workspaceFolder}', vim.fn.getcwd())
            -- Tell codesettings to use this new value
            return 'replace', expanded
          end
          -- Otherwise, leave it alone
          return 'continue'
        end
      }
    },
    
    lua_ls_integration = true,
    merge_lists = "append",
  },
  ft = { 'json', 'jsonc', 'lua' },
}
