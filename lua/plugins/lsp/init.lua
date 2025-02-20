return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		opts = {
			servers = {
				dockerls = {},
			},
			setup = {},
			format = {
				timeout_ms = 3000,
			},
		},
		config = function(plugin, opts)
			require("plugins.lsp.servers").setup(plugin, opts)
		end,
	},
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		cmd = "Mason",
		keys = { { "<leader>lm", "<cmd>Mason<cr>", desc = "Mason" } },
		opts = {
			ensure_installed = {
				"shfmt",
			},
		},
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require "mason-registry"
			local function ensure_installed()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end
			if mr.refresh then
				mr.refresh(ensure_installed)
			else
				ensure_installed()
			end
		end,
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
}

