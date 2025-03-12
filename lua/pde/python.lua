if not require("config").pde.python then
    return {}
end

return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "ninja", "python", "rst", "toml" })
        end,
    },
    {
        "williamboman/mason.nvim",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, {
                "pyright",  -- Serveur LSP Python
                "debugpy",  -- Débogueur Python
                "black",    -- Formateur Python
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        opts = function(_, opts)
            opts.servers.pyright = {
                settings = {
                    python = {
                        analysis = {
                            autoImportCompletions = true,
                            typeCheckingMode = "off",
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                            diagnosticMode = "openFilesOnly",
                            stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs/stubs",
                        },
                    },
                },
            }
            opts.setup = opts.setup or {}
            opts.setup.pyright = function(_, server_opts)
                server_opts.capabilities = vim.tbl_deep_extend(
                    "force", 
                    server_opts.capabilities or {}, 
                    require("cmp_nvim_lsp").default_capabilities() or {}
                )
                require("lspconfig").pyright.setup(server_opts)
                return true
            end
        end,
    },
    {
        "nvimtools/none-ls.nvim",
        opts = function(_, opts)
            local null_ls = require("null-ls")
            table.insert(opts.sources or {}, null_ls.builtins.formatting.black)
            return opts
        end,
    },
}