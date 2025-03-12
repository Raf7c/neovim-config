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
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "mfussenegger/nvim-dap-python",
            -- "rcarriga/nvim-dap-ui",
        },
        opts = {
            setup = {
                python = function(_, _)
                    local path = require("mason-registry").get_package("debugpy"):get_install_path()
                    require("dap-python").setup(path .. "/venv/bin/python")
                    
                    -- Configurations spécifiques pour les tests Python
                    local test_runners = require("dap-python").test_runners
                    test_runners.pytest = {
                        command = "pytest",
                        args = { "-v" },
                    }
                    
                    -- Raccourcis clavier spécifiques à Python pour le débogage
                    vim.keymap.set("n", "<leader>dPt", function() require("dap-python").test_method() end, { desc = "Debug Python Test Method" })
                    vim.keymap.set("n", "<leader>dPc", function() require("dap-python").test_class() end, { desc = "Debug Python Test Class" })
                    vim.keymap.set("n", "<leader>dPs", function() require("dap-python").debug_selection() end, { desc = "Debug Python Selection" })
                end,
            },
        },
    },
}