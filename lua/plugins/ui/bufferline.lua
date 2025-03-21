return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  event = "VeryLazy",
  keys = {
    { "<leader><tab>p", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
    { "<leader><tab>x", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
  },
  opts = {
    options = {
      mode = "tabs",
      diagnostics = "nvim_lsp",
      indicator = {
        icon = "▎",
        style = "icon",
      },
      modified_icon = "●",
      max_name_length = 30,
      tab_size = 21,
      separator_style = "thin",
      show_buffer_icons = false,
      show_tab_indicators = false,
      always_show_bufferline = true,
      enforce_regular_tabs = true,
      color_icons = false,
    },
  },
  config = function(_, opts)
    require("bufferline").setup(opts)
  end,
} 