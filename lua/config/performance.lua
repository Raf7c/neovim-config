local M = {}

-- General performance optimizations
function M.init()
  -- Disable diagnostics in insert mode
  vim.diagnostic.config({
    update_in_insert = false,
    severity_sort = true,
    underline = true,
    virtual_text = {
      spacing = 4,
      source = "if_many",
      prefix = "●",
    },
    float = {
      border = "rounded",
      source = "always",
    },
  })

  -- Optimize cache
  vim.fn.setenv("NVIM_RPLUGIN_MANIFEST", vim.fn.stdpath("data") .. "/rplugin.json")

  -- Disable unused built-in Neovim plugins
  local disabled_built_ins = {
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "gzip",
    "zip",
    "zipPlugin",
    "tar",
    "tarPlugin",
    "getscript",
    "getscriptPlugin",
    "vimball",
    "vimballPlugin",
    "2html_plugin",
    "logipat",
    "rrhelper",
    "spellfile_plugin",
    "matchit",
  }

  for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 1
  end

  -- Optimize LSP handlers
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, {
      border = "rounded",
      silent = true,
    }
  )
  
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help, {
      border = "rounded",
      silent = true,
    }
  )

  -- Configure document caching for LSP
  local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or "rounded"
    opts.max_width = opts.max_width or math.min(120, vim.o.columns * 0.8)
    opts.max_height = opts.max_height or math.min(30, vim.o.lines * 0.6)
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
  end

  -- Optimize refresh events
  vim.api.nvim_create_autocmd("TextChangedI", {
    pattern = "*",
    callback = function()
      vim.schedule(function()
        if vim.bo.buftype == "" then
          -- Limit operations in insert mode
        end
      end)
    end,
  })

  -- Optimize memory by cleaning cached buffers
  vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
      local count = 0
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_option(buf, "modifiable") and not vim.api.nvim_buf_get_option(buf, "modified") then
          count = count + 1
        end
      end
      
      if count > 15 then
        vim.schedule(function()
          -- Limit the number of buffers
          local bufs = vim.tbl_filter(function(buf)
            return vim.api.nvim_buf_is_valid(buf) 
              and vim.api.nvim_buf_get_option(buf, "modifiable") 
              and not vim.api.nvim_buf_get_option(buf, "modified")
              and vim.api.nvim_buf_get_option(buf, "buftype") == ""
          end, vim.api.nvim_list_bufs())
          
          table.sort(bufs, function(a, b)
            return vim.fn.getbufinfo(a)[1].lastused > vim.fn.getbufinfo(b)[1].lastused
          end)
          
          for i = 20, #bufs do
            vim.api.nvim_buf_delete(bufs[i], { force = false })
          end
        end)
      end
    end,
  })
end

return M 