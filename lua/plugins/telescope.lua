return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", enabled = vim.fn.executable "make" == 1, build = "make" },
    { "nvim-telescope/telescope-ui-select.nvim" },
  },
  config = require "plugins.configs.telescope",
}
