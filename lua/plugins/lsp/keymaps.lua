local M = {}

function M.on_attach(client, buffer)
	local self = M.new(client, buffer)

	-- Navigation
	self:map("gd", vim.lsp.buf.definition, { desc = "Goto Definition" })
	self:map("gr", vim.lsp.buf.references, { desc = "References" })
	self:map("gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
	self:map("gI", vim.lsp.buf.implementation, { desc = "Goto Implementation" })
	self:map("gy", vim.lsp.buf.type_definition, { desc = "Goto Type Definition" })
	self:map("K", vim.lsp.buf.hover, { desc = "Hover" })
	self:map("gK", vim.lsp.buf.signature_help, { desc = "Signature Help", has = "signatureHelp" })

	-- Diagnostics
	self:map("]d", M.diagnostic_goto(true), { desc = "Next Diagnostic" })
	self:map("[d", M.diagnostic_goto(false), { desc = "Prev Diagnostic" })
	self:map("]e", M.diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
	self:map("[e", M.diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
	self:map("]w", M.diagnostic_goto(true, "WARNING"), { desc = "Next Warning" })
	self:map("[w", M.diagnostic_goto(false, "WARNING"), { desc = "Prev Warning" })

	-- Actions
	self:map("<leader>la", vim.lsp.buf.code_action, { desc = "Code Action", mode = { "n", "v" }, has = "codeAction" })

	-- Formatage
	local format = require("plugins.lsp.format").format
	self:map("<leader>lf", format, { desc = "Format Document", has = "documentFormatting" })
	self:map("<leader>lf", format, { desc = "Format Range", mode = "v", has = "documentRangeFormatting" })

	-- Renommage
	self:map("<leader>lr", vim.lsp.buf.rename, { desc = "Rename", has = "rename" })

	-- Symboles - supprimés car dépendant de Telescope
	-- Remplacé par liste de symboles native si nécessaire
	self:map("<leader>ls", vim.lsp.buf.document_symbol, { desc = "Document Symbols" })
	self:map("<leader>lS", vim.lsp.buf.workspace_symbol, { desc = "Workspace Symbols" })

	-- Toggle diagnostics
	self:map("<leader>lw", require("plugins.lsp.utils").toggle_diagnostics, { desc = "Toggle Inline Diagnostics" })
end

function M.new(client, buffer)
	return setmetatable({ client = client, buffer = buffer }, { __index = M })
end

function M:has(cap)
	return self.client.server_capabilities[cap .. "Provider"]
end

function M:map(lhs, rhs, opts)
	opts = opts or {}
	if opts.has and not self:has(opts.has) then
		return
	end
	vim.keymap.set(
		opts.mode or "n",
		lhs,
		type(rhs) == "string" and ("<cmd>%s<cr>"):format(rhs) or rhs,
		---@diagnostic disable-next-line: no-unknown
		{ silent = true, buffer = self.buffer, expr = opts.expr, desc = opts.desc }
	)
end

-- Plus besoin de inc_rename pour rename
function M.rename()
	vim.lsp.buf.rename()
end

function M.diagnostic_goto(next, severity)
	local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function()
		go { severity = severity }
	end
end

return M
