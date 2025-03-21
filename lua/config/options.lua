local opts = {}
local opt = vim.opt

function opts.init()
	opt.modifiable = true
	-- Files & Encoding
	opt.fileencoding = "utf-8"
	opt.encoding = "utf-8"
	opt.autowrite = true
	opt.autoread = true
	opt.confirm = true
	opt.termguicolors = true
	
	-- Performance optimizations
	opt.lazyredraw = false
	opt.ttyfast = true
	opt.updatetime = 250
	opt.timeoutlen = 300
	opt.redrawtime = 1500
	opt.history = 100
	opt.undolevels = 1000

	-- Mouse & Clipboard
	opt.clipboard = "unnamedplus" -- System
	opt.mouse = "a"

	-- Display & UI
	opt.number = true
	opt.cursorline = true
	opt.wrap = false
	opt.signcolumn = "yes"
	opt.winbar = ""
	opt.laststatus = 3  -- Global statusline
	opt.scrolloff = 8   -- Keep 8 lines visible when scrolling
	opt.sidescrolloff = 8

	-- Indentation & Formatting
	opt.smartindent = true
	opt.tabstop = 2
	opt.shiftwidth = 2
	opt.expandtab = true

	-- Search
	opt.ignorecase = true
	opt.smartcase = true
	opt.hlsearch = true
	opt.incsearch = true

	-- Completion
	opt.completeopt = "menuone,noselect"
	opt.pumheight = 10

	-- Characters & Spacing
	opt.list = true
	opt.listchars:append("eol:↴")

	-- Window management & Splits
	opt.splitbelow = true
	opt.splitright = true
	
	-- Memory management
	opt.hidden = true
	opt.swapfile = false
	opt.backup = false
	opt.writebackup = false
	opt.undofile = true
end

return opts