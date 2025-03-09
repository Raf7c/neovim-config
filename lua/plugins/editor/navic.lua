return {
	"utilyre/barbecue.nvim",
	event = "VeryLazy",
	dependencies = {
		"neovim/nvim-lspconfig",
		"SmiteshP/nvim-navic",
		"nvim-tree/nvim-web-devicons",
	},
	enabled = true,
	config = function()
		local icons = require("config.icons")

		require("barbecue").setup({
			theme = "auto",
			include_buftypes = { "" },
			exclude_filetypes = { "gitcommit", "toggleterm" },
			show_modified = true,
			symbols = icons.kinds or icons,
		})

		-- icônes (optionnel)
		require("nvim-navic").setup({
			icons = icons.kinds or icons,
			highlight = true,
			separator = " ",
			depth_limit = 5,
		})
	end,
}
