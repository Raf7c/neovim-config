return {
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		cmd = "Neogit",
		keys = {
			{ "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit" },
		},
		opts = {
			integrations = {
				diffview = true,
				telescope = true,
			},
			kind = "tab",
			signs = {
				section = { "", "" },
				item = { "", "" },
				hunk = { "", "" },
			},
			sections = {
				untracked = {
					folded = false,
					hidden = false,
				},
				unstaged = {
					folded = false,
					hidden = false,
				},
				staged = {
					folded = false,
					hidden = false,
				},
				stashes = {
					folded = true,
					hidden = true,
				},
				unpulled = {
					folded = true,
					hidden = true,
				},
				unmerged = {
					folded = false,
					hidden = false,
				},
				recent = {
					folded = true,
					hidden = true,
				},
			},
		},
	},
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewFileHistory" },
		keys = {
			{ "<leader>gdo", "<cmd>DiffviewOpen<cr>", desc = "DiffView Open" },
			{ "<leader>gdc", "<cmd>DiffviewClose<cr>", desc = "DiffView Close" },
			{ "<leader>gdh", "<cmd>DiffviewFileHistory %<cr>", desc = "DiffView File History" },
			{ "<leader>gdH", "<cmd>DiffviewFileHistory<cr>", desc = "DiffView Branch History" },
			{ "<leader>gdr", "<cmd>DiffviewRefresh<cr>", desc = "DiffView Refresh" },
		},
		opts = {
			view = {
				default = {
					layout = "diff2_horizontal",
					winbar_info = false,
				},
				merge_tool = {
					layout = "diff3_horizontal",
					disable_diagnostics = true,
					winbar_info = true,
				},
				file_history = {
					layout = "diff2_horizontal",
					winbar_info = false,
				},
			},
			file_panel = {
				win_config = {
					position = "left",
					width = 35,
				},
			},
			commit_log_panel = {
				win_config = {
					position = "bottom",
					height = 16,
				},
			},
			default_args = {
				DiffviewOpen = { "--imply-local" },
			},
			hooks = {
				diff_buf_read = function()
					vim.opt_local.wrap = false
					vim.opt_local.list = false
					vim.opt_local.colorcolumn = ""
				end,
			},
			keymaps = {
				view = {
					q = "<cmd>DiffviewClose<cr>",
				},
				file_panel = {
					q = "<cmd>DiffviewClose<cr>",
				},
				file_history_panel = {
					q = "<cmd>DiffviewClose<cr>",
				},
			},
		},
	},
}
