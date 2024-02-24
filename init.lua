if vim.loader then vim.loader.enable() end

-- Source config files
for _, source in ipairs {
  "1-options",
  "2-lazy",
  "3-autocmd",
  "4-mappings",
} do
  local status_ok, fault = pcall(require, source)
  if not status_ok then vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault) end
end

-- Apply color scheme defined in ./lua/1-options.lua after all modules loaded
if base.default_colorscheme then
  if not pcall(vim.cmd.colorscheme, base.default_colorscheme) then
    require("base.utils").notify(
      "Error setting up colorscheme: " .. base.default_colorscheme,
      vim.log.levels.ERROR
    )
  end
end
