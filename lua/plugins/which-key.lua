return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    disable = { filetypes = { "TelescopePrompt" } },
  },
  config = require("plugins.configs.which-key"),
}
