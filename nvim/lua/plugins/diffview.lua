return {
  {
    "sindrets/diffview.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Diff/Merge Close" },
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff/Merge Open" },
    },
    config = function()
      require("diffview").setup({
        keymaps = {
          disable_defaults = false,
          view = {
            {
              "n",
              "<leader>ca",
              "<cmd>lua require('diffview.actions').conflict_choose('all')<cr>",
              {
                desc = "Choose all the versions of a conflict",
              },
            },
            ["<tab>"] = false,
            {
              "n",
              "<F12>",
              "<C-w>l",
              { desc = "Go to right window", remap = true },
            },
          },
        },
      })
    end,
  },
}
