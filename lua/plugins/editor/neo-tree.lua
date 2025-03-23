return {
	"nvim-neo-tree/neo-tree.nvim",
	keys = {
		{ "<leader>e", "<cmd>Neotree toggle reveal position=float<cr>", desc = "Toggle Neotree" },
		{ "<leader>t", "<cmd>Neotree toggle reveal position=left<cr>", desc = "Toggle Neotree (left)" },
	},
	opts = function()
		local icons = require("config.icons")

		return {
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
					added = "",
					modified = "",
					deleted = "✖",
					renamed = icons.git.FileRenamed,
					conflict = icons.git.FileUnmerged,
					untracked = icons.git.FileUntracked,
					ignored = icons.git.FileIgnored,
					unstaged = icons.git.FileUnstaged,
					staged = icons.git.FileStaged,
					typechange = icons.ui.Code,
				},
			},
			default_component_configs = {
				indent = {
					with_expanders = true,
					expander_collapsed = icons.ui.ChevronRight,
					expander_expanded = icons.ui.ChevronShortDown,
				},
				icon = {
					folder_closed = icons.ui.Folder,
					folder_open = icons.ui.FolderOpen,
					folder_empty = icons.ui.EmptyFolder,
					default = icons.ui.File,
					highlight = "NeoTreeFileIcon",
				},
			},
		}
	end,
	config = function(_, opts)
		require("neo-tree").setup(opts)
	end,
}
