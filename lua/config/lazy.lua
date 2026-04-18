local M = {}

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

local function bootstrap()
  if vim.uv.fs_stat(lazypath) then
    return
  end

  local url = "https://github.com/folke/lazy.nvim.git"
  local result = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    url,
    lazypath,
  })

  if vim.v.shell_error ~= 0 then
    error("lazy.nvim bootstrap failed:\n" .. result)
  end
end

M.setup = function()
  bootstrap()
  vim.opt.rtp:prepend(lazypath)

  require("lazy").setup({
    spec = {
      { import = "plugins" },
    },
    defaults = {
      lazy = true,
      version = false,
    },
    install = {
      colorscheme = { "tokyonight" },
    },
    checker = {
      enabled = false,
    },
    change_detection = {
      enabled = false,
      notify = false,
    },
    performance = {
      cache = {
        enabled = true,
      },
      rtp = {
        reset = false,
      },
    },
  })

  require("config.keymaps").setup()
  require("config.autocmds").setup()
end

return M
