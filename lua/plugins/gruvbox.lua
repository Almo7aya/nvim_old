return {
  "Almo7aya/gruvbox.nvim",
  priority = 1000,
  config = function()
    require("gruvbox").setup({
      dim_inactive = true,
      inverse = false,
    })

    pcall(vim.cmd.colorscheme, "gruvbox")
  end,
}
