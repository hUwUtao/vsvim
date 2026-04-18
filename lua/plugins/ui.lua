local plugin = require("utils.plugin_source")

return {
  {
    plugin.source("folke/snacks.nvim"),
    priority = 900,
    opts = {
      dashboard = { enabled = false },
      notifier = { enabled = false },
      picker = {
        enabled = true,
        win = {
          input = {
            keys = {
              ["<C-c>"] = { "close", mode = { "n", "i" } },
            },
          },
        },
      },
    },
  },
}
