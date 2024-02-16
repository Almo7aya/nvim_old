return function(_, opts)
  require("which-key").register({
    ["<leader>"] = {
      e = { "<cmd>Neotree toggle<cr>", "Toggle Explorer" },
    },
  }, opts)
end
