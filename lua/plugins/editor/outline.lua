return {
  "hedyhli/outline.nvim",
  cmd = { "Outline", "OutlineOpen" },
  keys = {
    { "<leader>co", "<cmd>Outline<cr>", desc = "Structure overview" },
  },
  opts = function()
    local icons = require("config.icons")
    return {
      outline_window = {
        position = "right",
      },
      symbols = {
        icons = {
          File = { icon = icons.kind.File },
          Module = { icon = icons.kind.Module },
          Namespace = { icon = icons.kind.Namespace },
          Package = { icon = icons.kind.Package },
          Class = { icon = icons.kind.Class },
          Method = { icon = icons.kind.Method },
          Property = { icon = icons.kind.Property },
          Field = { icon = icons.kind.Field },
          Constructor = { icon = icons.kind.Constructor },
          Enum = { icon = icons.kind.Enum },
          Interface = { icon = icons.kind.Interface },
          Function = { icon = icons.kind.Function },
          Variable = { icon = icons.kind.Variable },
          Constant = { icon = icons.kind.Constant },
          String = { icon = icons.kind.String },
          Number = { icon = icons.kind.Number },
          Boolean = { icon = icons.kind.Boolean },
          Array = { icon = icons.kind.Array },
          Object = { icon = icons.kind.Object },
          Key = { icon = icons.kind.Key },
          Null = { icon = icons.kind.Null },
          EnumMember = { icon = icons.kind.EnumMember },
          Struct = { icon = icons.kind.Struct },
          Event = { icon = icons.kind.Event },
          Operator = { icon = icons.kind.Operator },
          TypeParameter = { icon = icons.kind.TypeParameter },
        },
      },
      keymaps = {
        up_and_jump = "<up>",
        down_and_jump = "<down>",
      },
    }
  end,
} 