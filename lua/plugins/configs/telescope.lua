return function (_, _)
  local telescope = require("telescope")

  telescope.setup ({
    extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown {}
        }
      }
  })

  telescope.load_extension('ui-select')
end
