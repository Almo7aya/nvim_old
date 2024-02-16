return function(_, _)
  local lspconfig = require("lspconfig")
  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  lspconfig.lua_ls.setup({
    capabilities,
  })
  lspconfig.tsserver.setup({
    capabilities
  })
  lspconfig.eslint.setup({
    capabilities
  })

  vim.keymap.set("n", "H", vim.lsp.buf.hover, {})
  vim.keymap.set("n", "<Leader>la", vim.lsp.buf.code_action, {})
end
