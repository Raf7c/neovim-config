return {
  "catppuccin/nvim",
  lazy = false,
  priority = 1000,
  config = function()
    local catppuccin = require("catppuccin")

    catppuccin.setup({
      flavour = "latte",
      transparent_background = false,
    })

    vim.cmd.colorscheme "catppuccin"
  end,
}
