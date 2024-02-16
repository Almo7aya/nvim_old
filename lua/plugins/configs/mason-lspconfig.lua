return function(_, _)
  require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "tsserver" },
    auto_install = true
  })
end
