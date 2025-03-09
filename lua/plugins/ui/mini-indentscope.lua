return {
  "echasnovski/mini.indentscope",
  version = "*",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    symbol = "│",
    options = { try_as_border = true },
  },
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "Trouble",
        --"alpha",
        "dashboard",
        "fzf",
        "help",
        "lazy",
        "mason",
        "neo-tree",
        "notify",
        "toggleterm",
        "trouble",
      },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })
  end,
}