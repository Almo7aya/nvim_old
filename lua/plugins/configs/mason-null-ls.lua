-- TODO: REMOVE THIS UNNECESSARY FILE
return function()
  local null_ls = require 'null-ls'
  null_ls.setup()

  require ('mason-null-ls').setup({
      ensure_installed = {'stylua', 'jq'},
      handlers = {
          function() end, -- disables automatic setup of all null-ls sources
          stylua = function(source_name, methods)
            -- formatting
            null_ls.register(null_ls.builtins.formatting.stylua)
            --null_ls.register(null_ls.builtins.formatting.eslint)
            null_ls.register(null_ls.builtins.formatting.prettier)
            -- diagnostics
            --null_ls.register(null_ls.builtins.diagnostics.eslint)
          end,
          shfmt = function(source_name, methods)
            -- custom logic
            require('mason-null-ls').default_setup(source_name, methods) -- to maintain default behavior
          end,
      },
  })

  vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, {});
end
