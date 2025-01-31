return {
  "nvim-treesitter/nvim-treesitter",
  main = "nvim-treesitter.configs",
  opts = {
    auto_install = true,
    ensure_installed = {
      "lua",
      "javascript",
      "typescript",
      "html",
      "css",
    },
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
    },
  },
}

