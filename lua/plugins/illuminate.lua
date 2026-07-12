return {
  "RRethy/vim-illuminate",
  config = function()
    require("illuminate").configure({
      providers = {
        "lsp",
        "treesitter",
        "regex",
      },
      delay = 100,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
      filetypes_denylist = {
        "alpha",
        "dashboard",
        "neo-tree",
        "NvimTree",
        "Trouble",
        "fzf",
        "oil",
        "snacks_picker_list",
        "snacks_picker_input",
        "notify",
        "noice",
      },
    })
  end,
}
