return {
	"nvim-lua/plenary.nvim",
	"MunifTanjim/nui.nvim",
	{
		"nvim-tree/nvim-web-devicons",
		dependencies = { "DaikyXendo/nvim-material-icon" },
	},
	{ "yamatsum/nvim-nonicons", config = true, enabled = false },
	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
		  indent = {
			char = "│",
			tab_char = "│",
		  },
		  scope = { enabled = false },
		  exclude = {
			filetypes = {
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
		},
		main = "ibl",
	  },
}