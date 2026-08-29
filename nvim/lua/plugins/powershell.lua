return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        powershell_es = { enabled = false },
      },
    },
  },
  {
    "TheLeoP/powershell.nvim",
    ---@module 'powershell'
    ---@type powershell.user_config
    opts = {
      bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
      shell = "pwsh",
      settings = {
        powershell = {
          codeFormatting = {
            preset = "Allman",
            pipelineIndentationStyle = "NoIndentation",
            addWhitespaceAroundPipe = true,
            alignPropertyValuePairs = true,
            autoCorrectAliases = false,
            avoidSemicolonsAsLineTerminators = false,
            ignoreOneLineBlock = true,
            newLineAfterCloseBrace = true,
            newLineAfterOpenBrace = true,
            openBraceOnSameLine = false,
            trimWhitespaceAroundPipe = false,
            useConstantStrings = false,
            useCorrectCasing = false,
            whitespaceAfterSeparator = true,
            whitespaceAroundOperator = true,
            whitespaceAroundPipe = true,
            whitespaceBeforeOpenBrace = true,
            whitespaceBeforeOpenParen = true,
            whitespaceBetweenParameters = false,
            whitespaceInsideBrace = true,
          },
        },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "powershell-editor-services",
      },
    },
  },
}
