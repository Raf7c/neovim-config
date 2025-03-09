-- Initializing lazy leader key conf
vim.g.mapleader = " "
-- End lazy initialization
local opts = require("config.options")
opts.init()
local keymaps = require("config.keymaps")
keymaps.init()

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
		{ import = "plugins.colorscheme" },
		{ import = "plugins.ui" },
		{ import = "pde" },
	},
	defaults = { lazy = true, version = nil },
	install = { missing = true, colorscheme = { "catppuccin" } },
}
vim.keymap.set("n", "<leader>z", "<cmd>:Lazy<cr>", { desc = "Plugin Manager" })
