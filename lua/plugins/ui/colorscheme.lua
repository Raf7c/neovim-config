return {
  {
    "folke/styler.nvim",
    event = "VeryLazy", -- Chargement différé, mais pas désactivé
    opts = {
        themes = {
            markdown = { colorscheme = "tokyonight" },
            help = { colorscheme = "tokyonight" },
        },
    },
  },

  {
    "catppuccin/nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local catppuccin = require("catppuccin")
      catppuccin.setup({
        flavour = "mocha",
			  transparent_background = true,
      })
      vim.cmd.colorscheme "catppuccin"
    end,
  },
  {
    "folke/tokyonight.nvim",
}
}
