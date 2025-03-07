return {
	"lukas-reineke/indent-blankline.nvim",
	event = { "BufReadPost", "BufNewFile" },
	opts = function()
		-- Mapping simple pour activer/désactiver les guides d'indentation
		vim.keymap.set("n", "<leader>ug", function()
			local ibl = require("ibl")
			local config = require("ibl.config").get_config(0)
			ibl.setup_buffer(0, { enabled = not config.enabled })
			vim.notify("Indentation guides: " .. (not config.enabled and "On" or "Off"))
		end, { desc = "Toggle indentation guides" })

		return {
			indent = {
				char = "│",
				tab_char = "│",
			},
			scope = { show_start = false, show_end = false },
			exclude = {
				filetypes = {
					"Trouble",
					"dashboard",
					"help",
					"lazy",
					"mason",
					"neo-tree",
					"notify",
					"toggleterm",
					"trouble",
				},
			},
		}
	end,
	main = "ibl",
}
