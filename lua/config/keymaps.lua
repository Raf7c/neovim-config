local keymaps = {}

function keymaps.init()
	local keymap = vim.keymap
	-- No arrow key allowed
	keymap.set("n", "<up>", "<nop>", { silent = true })
	keymap.set("n", "<down>", "<nop>", { silent = true })
	keymap.set("n", "<left>", "<nop>", { silent = true })
	keymap.set("n", "<right>", "<nop>", { silent = true })

	-- ❌ Remove macro
	keymap.set("n", "q", "<nop>", { silent = true })

	-- Clear search
	keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch", silent = true })

	-- 💾 Save
	keymap.set("n", "<C-S>", "<CMD>w<CR>", { desc = "Save file", silent = true })

	-- Window management
	keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete window", silent = true })
	keymap.set("n", "<leader>ws", "<C-W>s", { desc = "Split window below", silent = true })
	keymap.set("n", "<leader>wv", "<C-W>v", { desc = "Split window right", silent = true })

	-- Tab management
	keymap.set("n", "<leader><tab>n", "<CMD>tabnew<CR>", { desc = "New Tab", silent = true })
	keymap.set("n", "<leader><tab>d", "<CMD>tabclose<CR>", { desc = "Close Tab", silent = true })
	keymap.set("n", "<leader><tab>n", "<CMD>tabnext<CR>", { desc = "Next tab", silent = true })
	keymap.set("n", "<leader><tab>p", "<CMD>tabprev<CR>", { desc = "Prev tab", silent = true })

	-- Move lines
	keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line up", silent = true })
	keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line down", silent = true })
end

return keymaps
