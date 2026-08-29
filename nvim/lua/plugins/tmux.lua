return {
  {
    "christoomey/vim-tmux-navigator",
    -- Suppress the plugin's own Ctrl+hjkl maps so the keys below are the only
    -- ones. Must be init, not config: the plugin installs them the moment it
    -- loads. This also drops its terminal-mode maps, which `mode` restores.
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    -- NOTE: LazyVim binds Ctrl+arrows to window resizing, but its
    -- safe_keymap_set skips any key a lazy `keys` spec already claims, so
    -- declaring them here wins without having to delete anything.
    keys = {
      { "<C-Left>", "<cmd>TmuxNavigateLeft<cr>", mode = { "n", "t" }, desc = "Go to Left Pane" },
      { "<C-Down>", "<cmd>TmuxNavigateDown<cr>", mode = { "n", "t" }, desc = "Go to Lower Pane" },
      { "<C-Up>", "<cmd>TmuxNavigateUp<cr>", mode = { "n", "t" }, desc = "Go to Upper Pane" },
      { "<C-Right>", "<cmd>TmuxNavigateRight<cr>", mode = { "n", "t" }, desc = "Go to Right Pane" },
      { "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>", mode = { "n", "t" }, desc = "Go to Previous Pane" },
    },
  },
}
