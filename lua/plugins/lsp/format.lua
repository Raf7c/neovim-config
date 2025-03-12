local M = {}

M.autoformat = true
M.format_notify = false
M.timeout_ms = 3000 

function M.toggle()
  M.autoformat = not M.autoformat
  vim.notify(M.autoformat and "Enabled format on save" or "Disabled format on save")
  return M.autoformat
end

function M.format(opts)
  opts = opts or {}
  local buf = opts.buf or vim.api.nvim_get_current_buf()
  local timeout_ms = opts.timeout_ms or M.timeout_ms
  
  -- Using the Neovim 0.10 formatting API
  local clients = vim.lsp.get_active_clients({ bufnr = buf })
  local client_ids = {}
  
  for _, client in ipairs(clients) do
    if M.supports_format(client) then
      table.insert(client_ids, client.id)
    end
  end

  if #client_ids == 0 then
    if M.format_notify then
      vim.notify("No LSP client with formatting capability", vim.log.levels.WARN)
    end
    return
  end

  -- Buffer formatting with available LSP clients
  vim.lsp.buf.format({
    bufnr = buf,
    filter = function(client)
      return vim.tbl_contains(client_ids, client.id)
    end,
    timeout_ms = timeout_ms,
  })
  
  if M.format_notify then
    vim.notify("Format applied", vim.log.levels.INFO)
  end
end

function M.format_range(start_line, end_line, opts)
  opts = opts or {}
  local buf = opts.buf or vim.api.nvim_get_current_buf()
  local timeout_ms = opts.timeout_ms or M.timeout_ms
  
  -- Formatting a specific range
  vim.lsp.buf.format({
    bufnr = buf,
    range = {
      ["start"] = { start_line, 0 },
      ["end"] = { end_line, 0 },
    },
    timeout_ms = timeout_ms,
  })
end

function M.supports_format(client)
  if client.config and client.config.capabilities and client.config.capabilities.documentFormattingProvider == false then
    return false
  end
  return client.supports_method("textDocument/formatting") or client.supports_method("textDocument/rangeFormatting")
end

function M.get_formatters(bufnr)
  local ret = {
    active = {},
    available = {},
  }

  local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    if M.supports_format(client) then
      table.insert(ret.active, client)
    end
  end

  return ret
end

function M.on_attach(client, bufnr)
  -- Create a unique augroup for this buffer
  local augroup_name = "LspFormat." .. bufnr
  local group = vim.api.nvim_create_augroup(augroup_name, {})
  
  -- Configuring automatic formatting on backup
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    buffer = bufnr,
    callback = function()
      if M.autoformat then
        M.format({ buf = bufnr })
      end
    end,
  })
  
  -- Cleaning the augroup when the buffer is closed
  vim.api.nvim_create_autocmd("BufDelete", {
    group = group,
    buffer = bufnr,
    callback = function()
      vim.api.nvim_del_augroup_by_name(augroup_name)
    end,
    once = true,
  })
end

return M