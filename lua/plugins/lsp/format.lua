local M = {}

M.autoformat = true
M.format_notify = false

function M.toggle()
  M.autoformat = not M.autoformat
  vim.notify(M.autoformat and "Enabled format on save" or "Disabled format on save")
end

function M.format()
  local buf = vim.api.nvim_get_current_buf()
  
  -- Simplification: utiliser directement les clients LSP pour le formatage
  local clients = vim.lsp.get_active_clients({ bufnr = buf })
  local client_ids = {}
  
  for _, client in ipairs(clients) do
    if M.supports_format(client) then
      table.insert(client_ids, client.id)
    end
  end

  if #client_ids == 0 then
    return
  end

  vim.lsp.buf.format({
    bufnr = buf,
    filter = function(client)
      return vim.tbl_contains(client_ids, client.id)
    end,
    timeout_ms = 3000,
  })
end

function M.supports_format(client)
  if client.config and client.config.capabilities and client.config.capabilities.documentFormattingProvider == false then
    return false
  end
  return client.supports_method "textDocument/formatting" or client.supports_method "textDocument/rangeFormatting"
end

function M.get_formatters(bufnr)
  local ret = {
    active = {},
    available = {},
  }

  local clients = vim.lsp.get_active_clients { bufnr = bufnr }
  for _, client in ipairs(clients) do
    if M.supports_format(client) then
      table.insert(ret.active, client)
    end
  end

  return ret
end

function M.on_attach(_, bufnr)
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("LspFormat." .. bufnr, {}),
    buffer = bufnr,
    callback = function()
      if M.autoformat then
        M.format()
      end
    end,
  })
end

return M