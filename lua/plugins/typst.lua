return {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    version = "1.*",
    build = function()
        require("typst-preview").update()
    end,
    opts = {
        debug = false,
        open_cmd = "chromium --app=%s --ozone-platform-hint=auto > /dev/null 2>&1", 
        port = 0,
        host = "127.0.0.1",
        invert_colors = "never",
        follow_cursor = true,
        dependencies_bin = {
            tinymist = "tinymist",
            websocat = nil,
        },
        extra_args = nil,
        get_root = function(path_of_main_file)
            local root = os.getenv("TYPST_ROOT")
            if root then
                return root
            end

            local main_dir = vim.fs.dirname(vim.fn.fnamemodify(path_of_main_file, ":p"))
            local found = vim.fs.find({ "typst.toml", ".git" }, { path = main_dir, upward = true })
            if #found > 0 then
                return vim.fs.dirname(found[1])
            end

            return main_dir
        end,
        get_main_file = function(path_of_buffer)
            return path_of_buffer
        end,
    },
    keys = {
        { "<leader>tt", "<cmd>TypstPreviewToggle<cr>", desc = "Toggle Typst Preview" },
        { "<leader>ts", "<cmd>TypstPreviewSyncCursor<cr>", desc = "Sync Cursor to Preview" },
        { "<leader>tP", function()
            local pdf = vim.fn.expand('%:p:r') .. ".pdf"
            vim.fn.jobstart({ "typst", "compile", vim.fn.expand('%:p'), pdf }, { detach = true })
            print("Exporting PDF...")
        end, desc = "Export Typst to PDF" },
    },
}
