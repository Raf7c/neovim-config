return {
  "nvim-neo-tree/neo-tree.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<leader>e", "<cmd>Neotree toggle reveal position=float<cr>", desc = "Toggle Neotree" },
  },
  opts = {
    enable_git_status = true,
    enable_diagnostics = true,
    filesystem = {
      follow_current_file = {
        enabled = true,
        leave_dirs_open = false,
      },
    },
  },
}