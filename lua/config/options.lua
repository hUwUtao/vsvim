local M = {}

M.setup = function()
  local opt = vim.opt
  local path_sep = package.config:sub(1, 1) == "\\" and ";" or ":"
  local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"

  if vim.fn.isdirectory(mason_bin) == 1 then
    local current_path = vim.env.PATH or ""
    if not current_path:find(mason_bin, 1, true) then
      vim.env.PATH = mason_bin .. path_sep .. current_path
    end
  end

  opt.autowrite = true
  opt.backspace = { "indent", "eol", "start" }
  opt.clipboard = "unnamedplus"
  opt.completeopt = { "menu", "menuone", "noselect" }
  opt.confirm = true
  opt.cursorline = true
  opt.expandtab = true
  opt.ignorecase = true
  opt.inccommand = "split"
  opt.linebreak = true
  opt.mouse = "a"
  opt.number = true
  opt.pumheight = 10
  opt.relativenumber = false
  opt.scrolloff = 4
  opt.shiftwidth = 2
  opt.showmode = false
  opt.signcolumn = "yes"
  opt.smartcase = true
  opt.smartindent = true
  opt.smoothscroll = true
  opt.softtabstop = 2
  opt.splitbelow = true
  opt.splitright = true
  opt.tabstop = 2
  opt.termguicolors = true
  opt.timeoutlen = 300
  opt.undofile = true
  opt.updatetime = 200
  opt.wrap = false

  opt.keymodel = {}
  opt.selectmode = {}
  opt.mousemodel = "extend"
  opt.whichwrap:append("<>[]hl")

  vim.g.snacks_animate = false
end

return M
