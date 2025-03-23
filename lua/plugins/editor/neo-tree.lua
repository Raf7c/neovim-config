return {
	"nvim-neo-tree/neo-tree.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	keys = {
		{ "<leader>e", "<cmd>Neotree toggle reveal position=float<cr>", desc = "Toggle Neotree" },
		{ "<leader>t", "<cmd>Neotree toggle reveal position=left<cr>", desc = "Toggle Neotree (left)" },
	},
	opts = {
		popup_border_style = "rounded",
		enable_git_status = true,
		enable_diagnostics = true,
		open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
		sort_function = nil,
		filesystem = {
			bind_to_cwd = false,
			follow_current_file = { enabled = true },
			use_libuv_file_watcher = true,
		},
		window = {
			position = "left",
			width = 35,
		},

		git_status = {
			symbols = {
				added = "✚",
				modified = "●",
				deleted = "✖",
				renamed = "󰁕",
				conflict = "",
				untracked = "★",
				ignored = "◌",
				unstaged = "󰄱",
				staged = "✓",
				typechange = "󰉿",
			},
		},
		default_component_configs = {
			indent = {
				with_expanders = true,
				expander_collapsed = "󰅀",
				expander_expanded = "󰅁",
			},
			icon = {
				folder_closed = "󰉋",
				folder_open = "󰝰",
				folder_empty = "󰜌",
				default = "󰈚",
				highlight = "NeoTreeFileIcon",
			},
		},
	},
	config = function(_, opts)
		require("neo-tree").setup(opts)
	end,
}
