return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      {

        "onsails/lspkind.nvim",
        lazy = true,
        opts = {
          mode = "symbol",
          symbol_map = {
            Array = "󰅪",
            Boolean = "⊨",
            Class = "󰌗",
            Constructor = "",
            Key = "󰌆",
            Namespace = "󰅪",
            Null = "NULL",
            Number = "#",
            Object = "󰀚",
            Package = "󰏗",
            Property = "",
            Reference = "",
            Snippet = "",
            String = "󰀬",
            TypeParameter = "󰊄",
            Unit = "",
          },
          menu = {},
        },
        enabled = true,
        config = function(_, opts) require("lspkind").init(opts) end,
      },
    },
    opts = function()
      local cmp = require("cmp")
      local luasnip = require ("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()

      local lspkind = require "lspkind"

      local border_opts = {
        border = "rounded",
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
      }

      local function has_words_before()
        local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      return {
        enabled = true,
        preselect = cmp.PreselectMode.None,
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          -- format = lspkind_status_ok and lspkind.cmp_format(utils.plugin_opts("lspkind.nvim")) or nil,
        },
        duplicates = {
          nvim_lsp = 1,
          luasnip = 1,
          cmp_tabnine = 1,
          buffer = 1,
          path = 1,
        },
        confirm_opts = {
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        },
        window = {
          completion = cmp.config.window.bordered(border_opts),
          documentation = cmp.config.window.bordered(border_opts),
        },
        mapping = {
          ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
          ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<C-y>"] = cmp.config.disable,
          ["<C-e>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip", priority = 750 },
          { name = "buffer",   priority = 500 },
          { name = "path",     priority = 250 },
        }),
      }
    end,
  },
}
