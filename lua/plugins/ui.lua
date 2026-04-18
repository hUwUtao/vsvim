local plugin = require("utils.plugin_source")

return {
  {
    plugin.source("Mofiqul/vscode.nvim"),
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.background = "dark"
      require("vscode").setup({
        transparent = false,
        italic_comments = false,
        italic_inlayhints = false,
        underline_links = true,
        disable_nvimtree_bg = true,
        terminal_colors = true,
      })
      vim.cmd.colorscheme("vscode")
      require("utils.statusline").setup()
    end,
  },
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
