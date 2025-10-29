return {
    "goolord/alpha-nvim",

    -- `VimEnter` is the correct event for a dashboard. It ensures the dashboard
    -- only appears after Neovim has fully initialized, but only on startup
    -- when no files are specified.
    event = "VimEnter",

    -- The config function is the ideal place to perform the setup.
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        -- Configure the dashboard header with ASCII art
        dashboard.section.header.val = {
            [[                               __                ]],
            [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
            [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
            [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
            [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
            [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
        }

        -- Configure the dashboard buttons
        dashboard.section.buttons.val = {
            dashboard.button("f", " " .. " Find file", ':lua require("fzf-lua").files() <CR>'),
            dashboard.button("e", " " .. " New file", ":ene <BAR> startinsert <CR>"),
            dashboard.button("c", " " .. " Nvim Config", ":e ~/.config/nvim/init.lua <CR>"),
            dashboard.button("o", " " .. " Recent files", ':lua require("fzf-lua").oldfiles()<CR>'),
            dashboard.button(
                "p",
                " " .. " Find project",
                ":lua require('telescope').extensions.projects.projects()<CR>"
            ),
            dashboard.button("q", " " .. " Quit", ":qa<CR>"),
        }

        -- Set the highlight groups for the dashboard sections
        dashboard.section.footer.opts.hl = "Type"
        dashboard.section.header.opts.hl = "Include"
        dashboard.section.buttons.opts.hl = "Keyword"

        -- Ensure no autocommands are triggered by the dashboard
        dashboard.opts.opts.noautocmd = true

        -- Set up alpha-nvim with the fully configured dashboard options
        alpha.setup(dashboard.opts)
    end,
}
