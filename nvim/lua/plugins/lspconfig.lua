return {
  -- Disable terraform-ls from the extra
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        terraformls = { enabled = false },
        lua_ls = {
          mason = false,
          cmd = { "lua-language-server" },
        },
        typos_lsp = {
          mason = true,
          cmd = { "typos-lsp" },
          root_markers = { "typos.toml", "_typos.toml", ".typos.toml" },
        },
        cssls = {},
        bashls = {},
        -- Mason builds nil from source and needs cargo, which isn't installed.
        -- The rest of the nix extra (treesitter, nixfmt, statix) still applies.
        nil_ls = { enabled = false },
        -- oxc replaced eslint/prettier in una-web. The nixpkgs `oxlint` ships no
        -- separate `oxc_language_server`, but the CLI serves LSP itself. Comes
        -- from the project devshell so the version matches CI.
        oxlint = {
          mason = false,
          cmd = { "oxlint", "--lsp" },
        },
        vtsls = {
          settings = {
            typescript = {
              -- una-web imports through the tsconfig `paths` aliases
              -- (`common/…`, `config/…`); keep auto-imports in that style.
              preferences = {
                importModuleSpecifier = "non-relative",
              },
              tsserver = {
                maxTsServerMemory = 8192,
              },
            },
          },
        },
      },
    },
  },
  -- Add tofu-ls manually since LazyVim doesn't support it natively yet
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local lspconfig = require("lspconfig")
      local configs = require("lspconfig.configs")

      if not configs.tofu_ls then
        configs.tofu_ls = {
          default_config = {
            cmd = { "tofu-ls", "serve" },
            filetypes = { "terraform", "terraform-vars", "tf" },
            root_dir = lspconfig.util.root_pattern(".terraform", ".git"),
          },
        }
      end

      opts.servers = opts.servers or {}
      opts.servers.tofu_ls = {}
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        terraform = { "tofu_fmt" },
        ["terraform-vars"] = { "tofu_fmt" },
        tf = { "tofu_fmt" },
        javascript = { "oxfmt" },
        javascriptreact = { "oxfmt" },
        typescript = { "oxfmt" },
        typescriptreact = { "oxfmt" },
        json = { "oxfmt" },
        jsonc = { "oxfmt" },
        css = { "oxfmt" },
        graphql = { "oxfmt" },
      },
      formatters = {
        tofu_fmt = {
          command = "tofu",
          args = { "fmt", "-" },
          stdin = true,
        },
        -- oxfmt reads .oxfmtrc.json from its cwd, not from the file being
        -- formatted, and una-web's settings (no semicolons, single quotes) are
        -- nothing like the defaults. Pinning cwd to the config keeps
        -- format-on-save in sync with `make fmt-check`; require_cwd makes it
        -- decline elsewhere rather than reformat with defaults.
        oxfmt = {
          command = "oxfmt",
          args = { "--stdin-filepath", "$FILENAME" },
          stdin = true,
          cwd = require("conform.util").root_file({ ".oxfmtrc.json" }),
          require_cwd = true,
        },
      },
    },
  },
}
