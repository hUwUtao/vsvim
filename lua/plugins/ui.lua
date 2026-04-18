return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight-moon")
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 900,
    opts = {
      dashboard = { enabled = false },
      input = { enabled = true },
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
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = {
      lsp = {
        progress = { enabled = false },
        signature = { enabled = false },
      },
      notify = {
        enabled = false,
      },
      presets = {
        command_palette = true,
        long_message_to_split = true,
      },
    },
  },
}
