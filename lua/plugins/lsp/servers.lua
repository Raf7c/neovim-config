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
      -- Improved configuration for Neovim 0.10
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

  -- Configuration diagnostics
  vim.diagnostic.config(config.diagnostic)

  -- Configuration of floating windows
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover,
    config.float
  )
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    config.float
  )
  
  -- Fix LspInfo behavior to open in a floating window
  -- instead of a new tab
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "lspinfo",
    callback = function()
      -- Apply rounded borders to the current window
      local win = vim.api.nvim_get_current_win()
      vim.wo[win].wrap = true
      -- Try to apply configuration if it's a floating window
      pcall(function()
        vim.api.nvim_win_set_config(win, {
          border = "rounded",
          title = " LSP Info ",
          title_pos = "center",
        })
      end)
    end,
  })
  
  -- Redefine LspInfo command to use a normal split instead of a tab
  vim.api.nvim_create_user_command("LspInfoFloat", function()
    -- Create a floating window
    local width = math.min(vim.o.columns - 4, 120)
    local height = math.min(vim.o.lines - 4, 40)
    local buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, true, {
      relative = "editor",
      width = width,
      height = height,
      row = (vim.o.lines - height) / 2,
      col = (vim.o.columns - width) / 2,
      style = "minimal",
      border = "rounded",
      title = " Detailed LSP Info ",
      title_pos = "center",
    })
    
    -- Buffer configuration
    vim.api.nvim_buf_set_option(buf, "filetype", "lspinfo")
    vim.api.nvim_win_set_option(win, "wrap", true)
    
    -- Get information about LSP clients
    local lines = {"# Active LSP Clients", ""}
    local clients = vim.lsp.get_active_clients()
    
    -- Helper to format tables and objects in a readable way
    local function format_table(tbl, indent_level)
      if type(tbl) ~= "table" then
        return tostring(tbl)
      end
      
      indent_level = indent_level or 0
      local indent = string.rep("  ", indent_level)
      local result = {}
      
      for k, v in pairs(tbl) do
        local key = tostring(k)
        if type(v) == "table" then
          table.insert(result, indent .. key .. ":")
          local formatted = format_table(v, indent_level + 1)
          if #formatted > 0 then
            for _, line in ipairs(formatted) do
              table.insert(result, line)
            end
          else
            table.insert(result, indent .. "  {}")
          end
        elseif type(v) == "function" then
          table.insert(result, indent .. key .. ": <function>")
        else
          table.insert(result, indent .. key .. ": " .. tostring(v))
        end
      end
      
      return result
    end
    
    -- Function to add a section to the display
    local function add_section(title, content)
      table.insert(lines, "## " .. title)
      
      if type(content) == "table" then
        if vim.tbl_isempty(content) then
          table.insert(lines, "  No information available")
        else
          local formatted = format_table(content, 1)
          for _, line in ipairs(formatted) do
            table.insert(lines, line)
          end
        end
      else
        table.insert(lines, "  " .. tostring(content))
      end
      
      table.insert(lines, "")
    end
    
    if #clients == 0 then
      table.insert(lines, "No active LSP clients")
    else
      for i, client in ipairs(clients) do
        table.insert(lines, "# Client " .. i .. ": " .. client.name)
        table.insert(lines, "")
        
        -- Basic information
        add_section("Basic Information", {
          ID = client.id,
          Name = client.name,
          Version = client.version or "Not specified",
          ["Server Type"] = client.server_info and client.server_info.name or "Not specified",
          ["Root Directory"] = client.config.root_dir or "Not specified",
          PID = client.rpc and client.rpc.pid or "Not available",
        })
        
        -- Workspace folders
        local workspace_folders = {}
        if client.workspace_folders then
          for _, folder in ipairs(client.workspace_folders) do
            table.insert(workspace_folders, folder.name)
          end
        end
        add_section("Workspace Folders", #workspace_folders > 0 and workspace_folders or "None")
        
        -- Attached buffers
        local attached_buffers = {}
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          if vim.lsp.buf_is_attached(bufnr, client.id) then
            local name = vim.api.nvim_buf_get_name(bufnr)
            if name and name ~= "" then
              table.insert(attached_buffers, {
                ["Buffer ID"] = bufnr,
                Path = vim.fn.fnamemodify(name, ":~:."),
              })
            end
          end
        end
        add_section("Attached Buffers", #attached_buffers > 0 and attached_buffers or "None")
        
        -- Server capabilities
        local capabilities = {}
        if client.server_capabilities then
          local caps = client.server_capabilities
          capabilities = {
            Diagnostic = caps.diagnosticProvider ~= nil,
            ["Completion"] = caps.completionProvider ~= nil,
            ["Definition"] = caps.definitionProvider == true,
            ["References"] = caps.referencesProvider == true,
            ["Formatting"] = caps.documentFormattingProvider == true,
            ["Range Formatting"] = caps.documentRangeFormattingProvider == true,
            ["Hover"] = caps.hoverProvider == true,
            ["Signature"] = caps.signatureHelpProvider ~= nil,
            ["Rename"] = caps.renameProvider ~= nil,
            ["Code Action"] = caps.codeActionProvider ~= nil,
            ["Inlay Hints"] = caps.inlayHintProvider ~= nil,
            ["CodeLens"] = caps.codeLensProvider ~= nil,
            ["Semantic Tokens"] = caps.semanticTokensProvider ~= nil,
            ["Document Symbols"] = caps.documentSymbolProvider == true,
            ["Workspace Symbols"] = caps.workspaceSymbolProvider == true,
            ["Call Hierarchy"] = caps.callHierarchyProvider ~= nil,
            ["Type Hierarchy"] = caps.typeHierarchyProvider ~= nil,
            ["Folding"] = caps.foldingRangeProvider ~= nil,
            ["Selection Range"] = caps.selectionRangeProvider ~= nil,
          }
        end
        add_section("Server Capabilities", capabilities)
        
        -- Configuration
        local config = vim.deepcopy(client.config)
        -- Remove fields that are too large or not relevant
        config.capabilities = nil
        config.handlers = nil
        add_section("Configuration", config)
        
        -- Initialization options
        if client.config.settings then
          add_section("Initialization Options", client.config.settings)
        end
        
        -- Add a separator between clients
        if i < #clients then
          table.insert(lines, string.rep("-", 40))
          table.insert(lines, "")
        end
      end
    end
    
    -- Add lines to buffer
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    
    -- Define syntax for better readability
    vim.api.nvim_buf_set_option(buf, "syntax", "markdown")
    
    -- Define mappings to close the window
    vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<CR>", {
      nowait = true, noremap = true, silent = true
    })
    vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "<cmd>close<CR>", {
      nowait = true, noremap = true, silent = true
    })
  end, {})
  
  -- Create an alias to use our default floating version
  vim.api.nvim_create_user_command("LspInfo", function()
    vim.cmd("LspInfoFloat")
  end, {})
end

function M.setup(_, opts)
  lsp_utils.on_attach(function(client, bufnr)
    -- Configuring Formatting
    require("plugins.lsp.format").on_attach(client, bufnr)
    
    -- Configuring keymaps
    require("plugins.lsp.keymaps").on_attach(client, bufnr)
    
    -- Configuring inlay hints (Neovim 0.10+)
    if client.server_capabilities.inlayHintProvider and opts.inlay_hints and opts.inlay_hints.enabled then
      -- Make sure the value is a boolean
      local should_enable = opts.inlay_hints.enabled == true
      pcall(vim.lsp.inlay_hint.enable, bufnr, should_enable)
    end
    
    -- Configuring CodeLens (Neovim 0.10+)
    if client.server_capabilities.codeLensProvider then
      vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
        buffer = bufnr,
        callback = function()
          pcall(vim.lsp.codelens.refresh)
        end,
      })
    end
    
    -- Configuring semantic tokens (Neovim 0.10+)
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