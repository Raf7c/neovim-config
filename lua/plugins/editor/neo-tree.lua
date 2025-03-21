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
    { "<leader>t", "<cmd>Neotree toggle reveal position=left<cr>", desc = "Toggle Neotree (left)" },
  },
  opts = {
    enable_git_status = true,
    enable_diagnostics = true,
    window = {
      position = "right",
      width = 30,
    },
    filesystem = {
      follow_current_file = {
        enabled = true,
        leave_dirs_open = false,
      },
    },
    git_status = {
      symbols = {
        added = "✚",
        modified = "●",
        deleted = "✖",
        renamed = "󰁕",
        conflict = "",
        untracked = "★",
        ignored = "◌",
        unstaged = "󰄱",
        staged = "✓",
        typechange = "󰉿",
      },
    },
    default_component_configs = {
      indent = {
        with_expanders = true,
        expander_collapsed = "󰅀",
        expander_expanded = "󰅁",
      },
      icon = {
        folder_closed = "󰉋",
        folder_open = "󰝰",
        folder_empty = "󰉖",
        folder_empty_open = "󰉖",
        default = "󰈚",
      },
    },
  },
  config = function(_, opts)
    require("neo-tree").setup(opts)
  end,
}