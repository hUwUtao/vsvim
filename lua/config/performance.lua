local M = {}

M.setup = function()
  vim.g.mapleader = " "
  vim.g.maplocalleader = "\\"

  if vim.loader and vim.loader.enable then
    vim.loader.enable()
  end

  vim.g.loaded_perl_provider = 0
  vim.g.loaded_python3_provider = 0
  vim.g.loaded_ruby_provider = 0
  vim.g.loaded_node_provider = 0

  local disabled_builtins = {
    "2html_plugin",
    "getscript",
    "getscriptPlugin",
    "gzip",
    "logipat",
    "matchit",
    "matchparen",
    "netrw",
    "netrwFileHandlers",
    "netrwPlugin",
    "netrwSettings",
    "rrhelper",
    "tar",
    "tarPlugin",
    "tutor",
    "zip",
    "zipPlugin",
  }

  for _, plugin in ipairs(disabled_builtins) do
    vim.g["loaded_" .. plugin] = 1
  end
end

return M
