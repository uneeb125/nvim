return {
    {
        "glepnir/template.nvim",
        cmd = { "Template", "TemProject" },
        keys = {
            { "<leader>ft", mode = "n" },
        },
        config = function()
            local template = require("template")
            if not template.temp_dir then
                template.setup({
                    temp_dir = vim.fn.expand("~/.config/nvim/templates"),
                    author = "uneeb",
                    email = "",
                })
            end
        end,
    },
}
