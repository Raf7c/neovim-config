return {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  keys = {
    {
      "<leader>un",
      function()
        require("notify").dismiss({ silent = true, pending = true })
      end,
      desc = "Close notifications",
    },
  },
  opts = {
    timeout = 3000,
    max_width = 50,
    max_height = 10,
    stages = "fade",
    background_colour = "FloatShadow",
    icons = {
      ERROR = "",
      WARN = "",
      INFO = "",
      DEBUG = "",
      TRACE = "✎",
    },
  },
  config = function(_, opts)
    local notify = require("notify")
    notify.setup(opts)
    
    -- Replace vim.notify function with nvim-notify
    vim.notify = notify
    
    if pcall(require, "telescope") then
      require("telescope").load_extension("notify")
      vim.keymap.set("n", "<leader>fn", "<cmd>Telescope notify<cr>", { desc = "Notifications" })
    end
  end,
} 