return {
	-- Styler for applying specific themes to specific filetypes
	{
		"folke/styler.nvim",
		event = "VeryLazy",
		opts = {
			themes = {
				markdown = { colorscheme = "tokyonight" },
				help = { colorscheme = "tokyonight" },
			},
		},
	},

	-- Main theme: Catppuccin
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000, -- Ensure it loads before other plugins
		opts = {
			flavour = "mocha", -- latte, frappe, macchiato, mocha
			background = {
				light = "latte",
				dark = "mocha",
			},
			transparent_background = true,
			term_colors = true,
			dim_inactive = {
				enabled = false,
				shade = "dark",
				percentage = 0.15,
			},
			styles = {
				comments = { "italic" },
				conditionals = { "italic" },
				loops = {},
				functions = {},
				keywords = {},
				strings = {},
				variables = {},
				numbers = {},
				booleans = {},
				properties = {},
				types = {},
				operators = {},
			},
			integrations = {
				cmp = true,
				nvimtree = true,
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
			catppuccin.setup(opts)
			vim.cmd.colorscheme "catppuccin"
			
			-- Function to toggle between light and dark themes
			_G.toggle_theme = function()
				local current_flavor = vim.g.catppuccin_flavour or "mocha"
				local new_flavor = current_flavor == "latte" and "mocha" or "latte"
				
				vim.g.catppuccin_flavour = new_flavor
				catppuccin.setup({ flavour = new_flavor })
				vim.cmd.colorscheme "catppuccin"
				
				-- Adjust background and notify user
				vim.o.background = new_flavor == "latte" and "light" or "dark"
				vim.notify("Switched to " .. (new_flavor == "latte" and "light" or "dark") .. " theme", vim.log.levels.INFO)
			end
			
			-- Create command and keybinding for theme toggling
			vim.api.nvim_create_user_command("ToggleTheme", function() _G.toggle_theme() end, {})
			vim.keymap.set("n", "<leader>ut", _G.toggle_theme, { desc = "Toggle between light and dark themes" })
		end,
	},
	
	-- Secondary theme: Tokyo Night
	{
		"folke/tokyonight.nvim",
		lazy = true, -- Load on demand
		opts = {
			style = "moon", -- moon, storm, night, day
			transparent = true,
			terminal_colors = true,
			styles = {
				comments = { italic = true },
				keywords = { italic = true },
				functions = {},
				variables = {},
				sidebars = "dark",
				floats = "dark",
			},
			sidebars = { "qf", "help", "terminal", "packer" },
			day_brightness = 0.3,
			hide_inactive_statusline = false,
			dim_inactive = false,
			lualine_bold = false,
		},
	},
}
