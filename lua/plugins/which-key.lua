return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts_extend = { "spec" },
	opts = {
		preset = "helix",
		defaults = {},
		spec = {
			{
				mode = { "n", "v" },
				{ "<leader>t", group = "tabs" },
				{ "<leader>l", group = "code" },
				{ "<leader>d", group = "debug" },
				{ "<leader>f", group = "file/find" },
				{ "<leader>g", group = "git" },
				{ "<leader>s", group = "search" },
				{ "<leader>w", group = "Window" },

				--{ "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
			},
		},
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Keymaps (which-key)",
		},
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)
		if not vim.tbl_isempty(opts.defaults) then
			LazyVim.warn("which-key: opts.defaults is deprecated. Please use opts.spec instead.")
			wk.register(opts.defaults)
		end
	end,
}
