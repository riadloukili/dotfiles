return {
  "folke/snacks.nvim",
  keys = {
    {
      "<leader>E",
      function()
        Snacks.explorer({ cwd = vim.fn.getcwd() })
      end,
      desc = "Explorer Snacks (cwd)",
    },
    {
      "<leader>C",
      function()
        Snacks.explorer({ cwd = vim.g.original_cwd })
      end,
      desc = "Explorer Snacks (shell cwd)",
    },
  },
  opts = {
    image = {
      enabled = true,
    },
    picker = {
      sources = {
        explorer = {
          hidden = true,
          ignored = true,
          cwd = vim.fn.getcwd(),
          layout = { layout = { position = "right" } },
        },
      },
    },
  },
}
