return {
	-- Catppuccin theme with dark/light toggle
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000, -- Ensure it loads before other plugins
		opts = {
			flavour = "mocha", -- Default to dark theme
			transparent_background = true,
			term_colors = true,
			integrations = {
				cmp = true,
				neotree = true,
				telescope = true,
				notify = true,
				mini = true,
				indent_blankline = {
					enabled = true,
					colored_indent_levels = false,
				},
				dashboard = true,
				which_key = true,
				markdown = true,
				mason = true,
				noice = true,
				native_lsp = {
					enabled = true,
					virtual_text = {
						errors = { "italic" },
						hints = { "italic" },
						warnings = { "italic" },
						information = { "italic" },
					},
					underlines = {
						errors = { "underline" },
						hints = { "underline" },
						warnings = { "underline" },
						information = { "underline" },
					},
					inlay_hints = {
						background = true,
					},
				},
				treesitter = true,
				lsp_trouble = true,
			},
		},
		config = function(_, opts)
			local catppuccin = require("catppuccin")
			
			-- Initial setup with provided options
			catppuccin.setup(opts)
			vim.cmd("colorscheme catppuccin")
			vim.o.background = "dark"
			
			-- Function to toggle between dark (mocha) and light (latte) flavors
			_G.toggle_catppuccin = function()
				local current_flavor = vim.g.catppuccin_flavour or "mocha"
				local new_flavor = current_flavor == "mocha" and "latte" or "mocha"
				local mode = new_flavor == "latte" and "light" or "dark"
				
				-- Update configuration with new flavor
				vim.g.catppuccin_flavour = new_flavor
				catppuccin.setup({ flavour = new_flavor })
				
				-- Apply changes
				vim.cmd("colorscheme catppuccin")
				vim.cmd("set background=" .. mode)
				
				-- Force refresh
				vim.defer_fn(function()
					vim.cmd("colorscheme catppuccin")
					vim.cmd("redraw")
					vim.notify("Switched to Catppuccin " .. new_flavor .. " (" .. mode .. " theme)", vim.log.levels.INFO)
				end, 10)
			end
			
			-- Create command and keybinding for theme toggling
			vim.api.nvim_create_user_command("ToggleTheme", function() _G.toggle_catppuccin() end, {})
			vim.keymap.set("n", "<leader>ut", _G.toggle_catppuccin, { desc = "Toggle between dark and light themes" })
		end,
	},
}
