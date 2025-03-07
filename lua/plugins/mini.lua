return {
	{
		'echasnovski/mini.pairs',
		version = '*',
		event = "VeryLazy",
		opts = {},
	},

	{
		"echasnovski/mini.icons",
		lazy = true,
		opts = {
			file = {
				[".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
				["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
			},
			filetype = {
				dotenv = { glyph = "", hl = "MiniIconsYellow" },
			},
		},
		init = function()
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
	},

	{
		"echasnovski/mini.indentscope",
		version = "*",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			symbol = "│",
			options = { try_as_border = true },
		},
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"Trouble",
					"alpha",
					"dashboard",
					"fzf",
					"help",
					"lazy",
					"mason",
					"neo-tree",
					"notify",
					"toggleterm",
					"trouble",
				},
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})
		end,
	},

	{
		"echasnovski/mini.comment",
		event = "VeryLazy",
		opts = {
			options = {
				custom_commentstring = function()
					return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
				end,
			},
		},
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		lazy = true,
		opts = {
			enable_autocmd = false,
		},
	},

	{
		"echasnovski/mini.cursorword",
		version = "*",
		event = { "BufReadPre", "BufNewFile" },
		opts = {},
	},

	{
		"echasnovski/mini.surround",
		version = "*",
		event = "VeryLazy",
		keys = {
			{ "gsa", desc = "Add Surrounding",                     mode = { "n", "v" } },
			{ "gsd", desc = "Delete Surrounding" },
			{ "gsf", desc = "Find Right Surrounding" },
			{ "gsF", desc = "Find Left Surrounding" },
			{ "gsh", desc = "Highlight Surrounding" },
			{ "gsr", desc = "Replace Surrounding" },
			{ "gsn", desc = "Update `MiniSurround.config.n_lines`" },
		},
		opts = {
			mappings = {
				add = "gsa",        -- Add surrounding in Normal and Visual modes
				delete = "gsd",     -- Delete surrounding
				find = "gsf",       -- Find surrounding (to the right)
				find_left = "gsF",  -- Find surrounding (to the left)
				highlight = "gsh",  -- Highlight surrounding
				replace = "gsr",    -- Replace surrounding
				update_n_lines = "gsn", -- Update `n_lines`
			},
		},
	},

	{
		"echasnovski/mini.align",
		version = "*",
		event = "VeryLazy",
		opts = {},
	},
	{
		"echasnovski/mini.animate",
		event = "VeryLazy",
		cond = vim.g.neovide == nil,
		opts = function(_, opts)
			-- don't use animate when scrolling with the mouse
			local mouse_scrolled = false
			for _, scroll in ipairs({ "Up", "Down" }) do
				local key = "<ScrollWheel" .. scroll .. ">"
				vim.keymap.set({ "", "i" }, key, function()
					mouse_scrolled = true
					return key
				end, { expr = true })
			end

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "grug-far",
				callback = function()
					vim.b.minianimate_disable = true
				end,
			})

			--Shortcut to enable/disable animations
			vim.keymap.set("n", "<leader>ua", function()
				vim.g.minianimate_disable = not vim.g.minianimate_disable
				print("Mini Animate: " .. (vim.g.minianimate_disable and "Off" or "On"))
			end, { desc = "Toggle animations" })

			local animate = require("mini.animate")
			return vim.tbl_deep_extend("force", opts, {
				resize = {
					timing = animate.gen_timing.linear({ duration = 50, unit = "total" }),
				},
				scroll = {
					timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
					subscroll = animate.gen_subscroll.equal({
						predicate = function(total_scroll)
							if mouse_scrolled then
								mouse_scrolled = false
								return false
							end
							return total_scroll > 1
						end,
					}),
				},
			})
		end,
	},
}
