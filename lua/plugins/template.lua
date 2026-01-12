return {
    {
        "glepnir/template.nvim",
        cmd = { "Template", "TemProject" },
        config = function()
            require("template").setup({
                temp_dir = vim.fn.expand("~/.config/nvim/templates"),
                author = "uneeb",
                email = "",
            })
        end,
    },
}
