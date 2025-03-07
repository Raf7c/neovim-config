local M = {}

local lsp_utils = require "plugins.lsp.utils"
local icons = require "config.icons"

local function lsp_init()
  local signs = {
    { name = "DiagnosticSignError", text = icons.diagnostics.Error },
    { name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
    { name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
    { name = "DiagnosticSignInfo", text = icons.diagnostics.Info },
  }
  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
  end

  -- LSP handlers configuration
  local config = {
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
    },

    diagnostic = {
      -- Configuration améliorée pour Neovim 0.10
      virtual_text = {
        severity = {
          min = vim.diagnostic.severity.ERROR,
        },
        source = "if_many",
        prefix = "●",
      },
      float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
        format = function(d)
          local code = d.code or (d.user_data and d.user_data.lsp and d.user_data.lsp.code)
          if code then
            return string.format("%s [%s]", d.message, code):gsub("1. ", "")
          end
          return d.message
        end,
      },
      signs = {
        active = signs,
      },
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    },
  }

  -- Diagnostic configuration
  vim.diagnostic.config(config.diagnostic)

  -- Configuration des fenêtres flottantes
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover,
    config.float
  )
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    config.float
  )
end

function M.setup(_, opts)
  lsp_utils.on_attach(function(client, bufnr)
    -- Configuration du formatage
    require("plugins.lsp.format").on_attach(client, bufnr)
    
    -- Configuration des keymaps
    require("plugins.lsp.keymaps").on_attach(client, bufnr)
    
    -- Configuration des inlay hints (Neovim 0.10+)
    if client.server_capabilities.inlayHintProvider and opts.inlay_hints and opts.inlay_hints.enabled then
      -- Assurons-nous que la valeur est bien un booléen
      local should_enable = opts.inlay_hints.enabled == true
      pcall(vim.lsp.inlay_hint.enable, bufnr, should_enable)
    end
    
    -- Configuration de CodeLens (Neovim 0.10+)
    if client.server_capabilities.codeLensProvider then
      vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
        buffer = bufnr,
        callback = function()
          pcall(vim.lsp.codelens.refresh)
        end,
      })
    end
    
    -- Configuration de Semantic Tokens (Neovim 0.10+)
    if client.server_capabilities.semanticTokensProvider and opts.semantic_tokens and opts.semantic_tokens.enabled then
      client.server_capabilities.semanticTokensProvider = opts.semantic_tokens.enabled
    end
  end)

  lsp_init() -- diagnostics, handlers

  local servers = opts.servers
  local capabilities = lsp_utils.capabilities()

  local function setup(server)
    local server_opts = vim.tbl_deep_extend("force", {
      capabilities = capabilities,
    }, servers[server] or {})

    if opts.setup[server] then
      if opts.setup[server](server, server_opts) then
        return
      end
    elseif opts.setup["*"] then
      if opts.setup["*"](server, server_opts) then
        return
      end
    end
    require("lspconfig")[server].setup(server_opts)
  end

  -- get all the servers that are available through mason-lspconfig
  local has_mason, mlsp = pcall(require, "mason-lspconfig")
  local all_mslp_servers = {}
  if has_mason then
    all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
  end

  local ensure_installed = {} ---@type string[]
  for server, server_opts in pairs(servers) do
    if server_opts then
      server_opts = server_opts == true and {} or server_opts
      -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
      if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
        setup(server)
      else
        ensure_installed[#ensure_installed + 1] = server
      end
    end
  end

  if has_mason then
    mlsp.setup { ensure_installed = ensure_installed }
    mlsp.setup_handlers { setup }
  end
end

return M