return {
	"nickjvandyke/opencode.nvim",
	version = "*",
	dependencies = {
		{
			"folke/snacks.nvim",
			opts = {
				input = {},
				picker = {
					actions = {
						opencode_send = function(...)
							return require("opencode").snacks_picker_send(...)
						end,
					},
					win = {
						input = {
							keys = {
								["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
							},
						},
					},
				},
			},
		},
	},
	config = function()
		vim.g.opencode_opts = {
			events = {
				permissions = {
					edits = {
						enabled = false,
					},
				},
			},
		}
		vim.o.autoread = true
		-- Toggle
		vim.keymap.set({ "n", "t" }, "<leader>og", function()
			require("opencode").toggle()
		end, { desc = "Toggle opencode" })
		-- Ask / Open input
		vim.keymap.set({ "n", "x" }, "<leader>oi", function()
			require("opencode").ask("@this: ", { submit = true })
		end, { desc = "Ask opencode" })
		-- Visual selection
		vim.keymap.set("v", "<leader>oy", function()
			return require("opencode").operator("@this ")
		end, { desc = "Add visual selection to opencode", expr = true })
		-- Quick chat
		vim.keymap.set({ "n", "x" }, "<leader>o/", function()
			require("opencode").ask("@this: ", { submit = true })
		end, { desc = "Quick chat" })
		-- Select / Context
		vim.keymap.set("n", "<leader>gl", function()
			require("opencode").select()
		end, { desc = "Opencode select" })
		-- Scroll up/down
		vim.keymap.set("n", "<S-C-u>", function()
			require("opencode").command("session.half.page.up")
		end, { desc = "Scroll opencode up" })
		vim.keymap.set("n", "<S-C-d>", function()
			require("opencode").command("session.half.page.down")
		end, { desc = "Scroll opencode down" })
	end,
}
