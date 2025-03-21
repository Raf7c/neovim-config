return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-telescope/telescope-file-browser.nvim",
			"nvim-telescope/telescope-project.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
		},
		cmd = "Telescope",
		keys = {
			-- Vous pouvez ajouter vos raccourcis clavier Telescope ici
			{ "<leader>ff", "<cmd>Telescope find_files<cr>",   desc = "Find Files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>",    desc = "Live Grep" },
			{ "<leader>fo", "<cmd>Telescope oldfiles<cr>",     desc = "Recent" },
			{ "<leader>fr", "<cmd>Telescope file_browser<cr>", desc = "Browser" },
		},
		config = function(_, _)
			local telescope = require "telescope"
			local icons = require "config.icons"
			local actions = require "telescope.actions"
			local actions_layout = require "telescope.actions.layout"
			local mappings = {
				i = {
					["<C-j>"] = actions.move_selection_next,
					["<C-k>"] = actions.move_selection_previous,
					["<C-n>"] = actions.cycle_history_next,
					["<C-p>"] = actions.cycle_history_prev,
					["?"] = actions_layout.toggle_preview,
				},
			}
			local opts = {
				defaults = {
					prompt_prefix = icons.ui.Telescope .. " ",
					selection_caret = icons.ui.Forward .. " ",
					mappings = mappings,
					border = {},
					borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
					color_devicons = true,
				},
				pickers = {
					find_files = {
						theme = "dropdown",
						previewer = false,
						hidden = true,
						find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
					},
					git_files = {
						theme = "dropdown",
						previewer = false,
					},
					buffers = {
						theme = "dropdown",
						previewer = false,
					},
				},
				extensions = {
					file_browser = {
						theme = "dropdown",
						previewer = false,
						hijack_netrw = true,
						mappings = mappings,
					},
					project = {
						hidden_files = false,
						theme = "dropdown",
					},
					["ui-select"] = {
						theme = "dropdown",
					},
				},
			}
			telescope.setup(opts)
			telescope.load_extension "fzf"
			telescope.load_extension "file_browser"
			telescope.load_extension "project"
			telescope.load_extension "ui-select"
		end,
	},
}
