return {
	{
		"nvimtools/none-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
		},
		opts = function()
			local null_ls = require("null-ls")
			local sources = {
				-- Formate
				null_ls.builtins.formatting.stylua,  -- Formate for Lua
				null_ls.builtins.formatting.shfmt,   -- Formate for Shell
			}

			return {
				sources = sources,
				-- Automatic formatting when saving
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = false })
						vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								-- Checks if auto format is enabled
								if require("plugins.lsp.format").autoformat then
									vim.lsp.buf.format({
										bufnr = bufnr,
										filter = function(cli)
											return cli.name == "null-ls"
										end,
										timeout_ms = require("plugins.lsp.format").timeout_ms,
									})
								end
							end,
						})
					end
				end,
			}
		end,
		config = function(_, opts)
			require("null-ls").setup(opts)
		end,
	},
} 