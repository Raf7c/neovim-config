local keymaps = {}
local keymap = vim.keymap

function keymaps.init()
	-- No arrow key allowed
	keymap.set("n", "<up>", "<nop>", { silent = true })
	keymap.set("n", "<down>", "<nop>", { silent = true })
	keymap.set("n", "<left>", "<nop>", { silent = true })
	keymap.set("n", "<right>", "<nop>", { silent = true })

	-- Remove macro
	keymap.set("n", "q", "<nop>", { silent = true })

	-- Clear search
	keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch", silent = true })

	-- Save
	keymap.set("n", "<C-S>", "<CMD>w<CR>", { desc = "Save file", silent = true })

	-- Window management
	keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete window", silent = true })
	keymap.set("n", "<leader>wy", "<C-W>s", { desc = "Split window below", silent = true })
	keymap.set("n", "<leader>wx", "<C-W>v", { desc = "Split window right", silent = true })

	-- Tab management
end
return keymaps
