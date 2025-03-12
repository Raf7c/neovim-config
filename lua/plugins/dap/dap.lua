return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{ "rcarriga/nvim-dap-ui" },
			{ "theHamsta/nvim-dap-virtual-text" },
			{ "nvim-neotest/nvim-nio" },
		},
		-- stylua: ignore
		keys = {
			{ "<leader>dR", function() require("dap").run_to_cursor() end,                               desc = "Run to Cursor", },
			{ "<leader>dE", function() require("dapui").eval(vim.fn.input "[Expression] > ") end,        desc = "Evaluate Input", },
			{ "<leader>dC", function() require("dap").set_breakpoint(vim.fn.input "[Condition] > ") end, desc = "Conditional Breakpoint", },
			{ "<leader>dU", function() require("dapui").toggle() end,                                    desc = "Toggle UI", },
			{ "<leader>db", function() require("dap").step_back() end,                                   desc = "Step Back", },
			{ "<leader>dc", function() require("dap").continue() end,                                    desc = "Continue", },
			{ "<leader>dd", function() require("dap").disconnect() end,                                  desc = "Disconnect", },
			{ "<leader>de", function() require("dapui").eval() end,                                      mode = { "n", "v" },             desc = "Evaluate", },
			{ "<leader>dg", function() require("dap").session() end,                                     desc = "Get Session", },
			{ "<leader>dh", function() require("dap.ui.widgets").hover() end,                            desc = "Hover Variables", },
			{ "<leader>dS", function() require("dap.ui.widgets").scopes() end,                           desc = "Scopes", },
			{ "<leader>di", function() require("dap").step_into() end,                                   desc = "Step Into", },
			{ "<leader>do", function() require("dap").step_over() end,                                   desc = "Step Over", },
			{ "<leader>dp", function() require("dap").pause.toggle() end,                                desc = "Pause", },
			{ "<leader>dq", function() require("dap").close() end,                                       desc = "Quit", },
			{ "<leader>dr", function() require("dap").repl.toggle() end,                                 desc = "Toggle REPL", },
			{ "<leader>ds", function() require("dap").continue() end,                                    desc = "Start", },
			{ "<leader>dt", function() require("dap").toggle_breakpoint() end,                           desc = "Toggle Breakpoint", },
			{ "<leader>dx", function() require("dap").terminate() end,                                   desc = "Terminate", },
			{ "<leader>du", function() require("dap").step_out() end,                                    desc = "Step Out", },
		},
		opts = {
			setup = {}, -- Initialize setup as an empty table
		},
		config = function(plugin, opts)
			require("nvim-dap-virtual-text").setup {
				commented = true,
			}

			local dap, dapui = require "dap", require "dapui"
			dapui.setup {}

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- set up debugger
			if opts.setup then -- Vérifier que opts.setup existe avant d'itérer dessus
				for k, _ in pairs(opts.setup) do
					opts.setup[k](plugin, opts)
				end
			end
		end,
	},
	 -- mason.nvim integration
	 {
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = "mason.nvim",
		cmd = { "DapInstall", "DapUninstall" },
		opts = {
		  -- Makes a best effort to setup the various debuggers with
		  -- reasonable debug configurations
		  automatic_installation = true,
	
		  -- You can provide additional configuration to the handlers,
		  -- see mason-nvim-dap README for more information
		  handlers = {},
	
		  -- You'll need to check that you have the required things installed
		  -- online, please don't ask me how to install them :)
		  ensure_installed = {
			-- Update this to ensure that you have the debuggers for the langs you want
		  },
		},
		-- mason-nvim-dap is loaded when nvim-dap loads
		config = function() end,
	  },
}
