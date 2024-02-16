local utils = require("utils")
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local namespace = vim.api.nvim_create_namespace

vim.on_key(function(char)
  if vim.fn.mode() == "n" then
    local new_hlsearch = vim.tbl_contains({ "<CR>", "n", "N", "*", "#", "?", "/" }, vim.fn.keytrans(char))
    if vim.opt.hlsearch:get() ~= new_hlsearch then
      vim.opt.hlsearch = new_hlsearch
    end
  end
end, namespace("auto_hlsearch"))

autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  desc = "Check if buffers changed on editor focus",
  group = augroup("checktime", { clear = true }),
  command = "checktime",
})

autocmd({ "VimEnter", "FileType", "BufEnter", "WinEnter" }, {
  desc = "URL Highlighting",
  group = augroup("highlighturl", { clear = true }),
  callback = function()
    utils.set_url_match()
  end,
})

local view_group = augroup("auto_view", { clear = true })
autocmd({ "BufWinLeave", "BufWritePost", "WinLeave" }, {
  desc = "Save view with mkview for real files",
  group = view_group,
  callback = function(args)
    if vim.b[args.buf].view_activated then
      vim.cmd.mkview({ mods = { emsg_silent = true } })
    end
  end,
})
autocmd("BufWinEnter", {
  desc = "Try to load file view if available and enable view saving for real files",
  group = view_group,
  callback = function(args)
    if not vim.b[args.buf].view_activated then
      local filetype = vim.api.nvim_get_option_value("filetype", { buf = args.buf })
      local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })
      local ignore_filetypes = { "gitcommit", "gitrebase", "svg", "hgcommit" }
      if buftype == "" and filetype and filetype ~= "" and not vim.tbl_contains(ignore_filetypes, filetype) then
        vim.b[args.buf].view_activated = true
        vim.cmd.loadview({ mods = { emsg_silent = true } })
      end
    end
  end,
})

autocmd("BufWinEnter", {
  desc = "Make q close help, man, quickfix, dap floats",
  group = augroup("q_close_windows", { clear = true }),
  callback = function(args)
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })
    if vim.tbl_contains({ "help", "nofile", "quickfix" }, buftype) and vim.fn.maparg("q", "n") == "" then
      vim.keymap.set("n", "q", "<cmd>close<cr>", {
        desc = "Close window",
        buffer = args.buf,
        silent = true,
        nowait = true,
      })
    end
  end,
})

autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = augroup("highlightyank", { clear = true }),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank()
  end,
})

autocmd("FileType", {
  desc = "Unlist quickfist buffers",
  group = augroup("unlist_quickfist", { clear = true }),
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

autocmd("BufEnter", {
  desc = "Open Neo-Tree on startup with directory",
  group = augroup("neotree_start", { clear = true }),
  callback = function()
    if package.loaded["neo-tree"] then
      vim.api.nvim_del_augroup_by_name("neotree_start")
    else
      local stats = (vim.uv or vim.loop).fs_stat(vim.api.nvim_buf_get_name(0)) -- TODO: REMOVE vim.loop WHEN DROPPING SUPPORT FOR Neovim v0.9
      if stats and stats.type == "directory" then
        vim.api.nvim_del_augroup_by_name("neotree_start")
        require("neo-tree")
      end
    end
  end,
})
autocmd("TermClose", {
  pattern = "*lazygit*",
  desc = "Refresh Neo-Tree when closing lazygit",
  group = augroup("neotree_refresh", { clear = true }),
  callback = function()
    local manager_avail, manager = pcall(require, "neo-tree.sources.manager")
    if manager_avail then
      for _, source in ipairs({ "filesystem", "git_status", "document_symbols" }) do
        local module = "neo-tree.sources." .. source
        if package.loaded[module] then
          manager.refresh(require(module).name)
        end
      end
    end
  end,
})

autocmd("FileType", {
  desc = "configure editorconfig after filetype detection to override `ftplugin`s",
  group = augroup("editorconfig_filetype", { clear = true }),
  callback = function(args)
    if vim.F.if_nil(vim.b.editorconfig, vim.g.editorconfig, true) then
      local editorconfig_avail, editorconfig = pcall(require, "editorconfig")
      if editorconfig_avail then
        editorconfig.config(args.buf)
      end
    end
  end,
})
