local opts = {}
local opt = vim.opt

function opts.init()
	-- Files & Encoding
	opt.fileencoding = "utf-8"
	opt.encoding = "utf-8"
	opt.autowrite = true
	opt.autoread = true 
	opt.confirm = true

	-- Mouse & Clipboard
	opt.clipboard = ("unnamedplus") -- Systeme
	opt.mouse = "a"

	-- Display & UI
	opt.number = true 
	opt.cursorline = true
	opt.wrap = false
	opt.signcolumn = "yes"
	pcall(function() opt.winbar = "" end)

	-- Indentation & Formatting
	opt.smartindent = true  
	opt.tabstop = 2
	opt.shiftwidth = 2

	-- Characters & Spacing
	opt.list = true
	opt.listchars = ("eol:↴")

	-- Window management & Splits
	opt.splitbelow = true 
	opt.splitright = true
end
return opts
