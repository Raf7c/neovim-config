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
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" }, 
							},
							workspace = {
								library = {
									vim.fn.expand("$VIMRUNTIME/lua"),
									vim.fn.stdpath("config") .. "/lua",
								},
								checkThirdParty = false,
							},
							telemetry = { enable = false },
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
			},
			setup = {},
			format = {
				timeout_ms = 3000,
			},
			-- Inlay hints pour Neovim 0.10+
			inlay_hints = {
				enabled = true,
			},
			-- Support du folding sémantique
			semantic_tokens = {
				enabled = true,
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
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		opts = {
			ensure_installed = {
				"shfmt",    -- Formate for Shell
				"stylua",   -- Formate for Lua
			},
			ui = {
				border = "rounded",
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
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
		cmd = { "TroubleToggle", "Trouble" },
		keys = {
			{ "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics" },
			{ "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
		},
		opts = {
			auto_open = false,
			auto_close = true,
			use_diagnostic_signs = true,
		},
	},
	-- Import none-ls.lua
	require("plugins.lsp.none-ls"),
}