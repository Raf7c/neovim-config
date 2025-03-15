return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    signs_staged = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
    },
    worktrees = nil,
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
      end

      -- Navigation
      map("n", "<leader>gj", gs.next_hunk, "Next change")
      map("n", "<leader>gk", gs.prev_hunk, "Previous change")

      -- Actions
      map({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", "Stage hunk")
      map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", "Reset hunk")
      map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
      map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage")
      map("n", "<leader>gR", gs.reset_buffer, "Reset buffer")
      map("n", "<leader>gp", gs.preview_hunk, "Preview changes")
      map("n", "<leader>gl", function() gs.blame_line({ full = true }) end, "Blame")
      map("n", "<leader>gd", gs.diffthis, "Diff")
      map("n", "<leader>gD", function() gs.diffthis("~") end, "Diff with HEAD~1")
      map("n", "<leader>gtd", gs.toggle_deleted, "Toggle deleted")
      map("n", "<leader>gw", gs.toggle_word_diff, "Toggle word diff")
      map("n", "<leader>gl", gs.toggle_linehl, "Highlight changed lines")

      -- Text object for hunks
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk")
    end,
    watch_gitdir = {
      interval = 1000,
      follow_files = true,
    },
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol",
      delay = 500,
    },
    preview_config = {
      border = "rounded",
      style = "minimal",
    },
    update_debounce = 100,
    word_diff = true,
    linehl = false,
    numhl = false,
  },
} 