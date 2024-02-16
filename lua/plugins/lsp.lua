return  {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "williamboman/mason-lspconfig.nvim",
      cmd = { "LspInstall", "LspUninstall" },
      config = require "plugins.configs.mason-lspconfig",
    },
    {
        "jay-babu/mason-null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
          "williamboman/mason.nvim",
          "nvimtools/none-ls.nvim",
        },
        config = require "plugins.configs.mason-null-ls",
    }
  },
  config = require "plugins.configs.lspconfig",
}
