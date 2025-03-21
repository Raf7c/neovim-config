-- Initializing lazy leader key conf
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- End lazy initialization

-- Performance optimizations
vim.loader.enable()  -- Use the new faster loader
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

local opts = require("config.options")
opts.init()
local keymaps = require("config.keymaps")
keymaps.init()

-- Initialize performance optimizations
local perf = require("config.performance")
perf.init()

--- Install lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system {
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	}
end
vim.opt.rtp:prepend(lazypath)

-- Configure lazy.nvim
require("lazy").setup {
	spec = {
		{ import = "plugins" },
		{ import = "plugins.editor" },
		{ import = "plugins.coding" },
		{ import = "plugins.dap" },
		{ import = "plugins.colorscheme" },
		{ import = "plugins.ui" },
		{ import = "pde" },
	},
	defaults = { 
		lazy = true, 
		version = nil,
		event = "VeryLazy",  -- Load non-essential plugins after startup
	},
	install = { missing = true, colorscheme = { "catppuccin" } },
	performance = {
		cache = {
			enabled = true,
		},
		reset_packpath = true,
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
	ui = {
		icons = {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🔑",
			plugin = "🔌",
			runtime = "💻",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
	checker = {
		enabled = true,        -- Check for updates
		notify = false,        -- Don't notify about updates
		frequency = 3600 * 12, -- Check every 12 hours
	},
}
vim.keymap.set("n", "<leader>z", "<cmd>:Lazy<cr>", { desc = "Plugin Manager" })
