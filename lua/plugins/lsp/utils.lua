local M = {}

function M.capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  }
  
  -- Support du folding amélioré pour Neovim 0.10+
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
  
  -- Support des inlay hints pour Neovim 0.10+
  capabilities.textDocument.inlayHint = {
    dynamicRegistration = false,
    resolveSupport = {
      properties = {
        "tooltip",
        "textEdits",
        "kind",
        "label",
      },
    },
  }
  
  -- Support des semantic tokens pour Neovim 0.10+
  capabilities.textDocument.semanticTokens = {
    dynamicRegistration = false,
    tokenTypes = {"class", "comment", "enum", "function", "interface", "keyword", "namespace", "number", "parameter", "property", "string", "type", "variable"},
    tokenModifiers = {"declaration", "definition", "readonly", "static", "deprecated", "abstract", "async", "modification", "documentation", "defaultLibrary"},
    formats = {"relative"},
    requests = {
      range = true,
      full = {
        delta = true,
      },
    },
  }
  
  -- Intégration avec cmp_nvim_lsp
  return require("cmp_nvim_lsp").default_capabilities(capabilities)
end

function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, bufnr)
    end,
  })
end

local diagnostics_active = true

function M.show_diagnostics()
  return diagnostics_active
end

function M.toggle_diagnostics()
  diagnostics_active = not diagnostics_active
  if diagnostics_active then
    vim.diagnostic.show()
  else
    vim.diagnostic.hide()
  end
  
  return diagnostics_active
end

-- Nouvelles fonctions pour Neovim 0.10+
function M.toggle_inlay_hints()
  local bufnr = vim.api.nvim_get_current_buf()
  local enabled = vim.lsp.inlay_hint.is_enabled(bufnr)
  vim.lsp.inlay_hint.enable(bufnr, not enabled)
  vim.notify((not enabled) and "Enabled inlay hints" or "Disabled inlay hints")
end

function M.opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require "lazy.core.plugin"
  return Plugin.values(plugin, "opts", false)
end

return M