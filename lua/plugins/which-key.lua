return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = function()
		require("which-key").register({
			["<leader>d"] = { name = "+Diagnostics/Quickfix" },
			["<leader>f"] = { name = "+File/Find" },
			["<leader>g"] = { name = "+Git" },
			["<leader>l"] = { name = "+Lsp" },
			["<leader>t"] = { name = "+Tab" },
			["<leader>w"] = { name = "+Windows" },
		})
	end,
}
