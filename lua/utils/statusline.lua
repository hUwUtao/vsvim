local M = {}

local mode_names = {
  n = "NORMAL",
  i = "INSERT",
  v = "VISUAL",
  V = "VISUAL",
  ["\22"] = "BLOCK",
  s = "SELECT",
  S = "SELECT",
  ["\19"] = "BLOCK",
  R = "REPLACE",
  c = "COMMAND",
  r = "PROMPT",
  t = "TERMINAL",
}

local mode_highlights = {
  n = "VsvimStatusModeNormal",
  i = "VsvimStatusModeInsert",
  v = "VsvimStatusModeVisual",
  V = "VsvimStatusModeVisual",
  ["\22"] = "VsvimStatusModeVisual",
  s = "VsvimStatusModeSelect",
  S = "VsvimStatusModeSelect",
  ["\19"] = "VsvimStatusModeSelect",
  R = "VsvimStatusModeReplace",
  c = "VsvimStatusModeCommand",
  r = "VsvimStatusModeCommand",
  t = "VsvimStatusModeCommand",
}

local function filename()
  local name = vim.fn.expand("%:t")
  if name == "" then
    return "[No Name]"
  end
  return name
end

local function readonly_flag()
  if vim.bo.readonly or not vim.bo.modifiable then
    return " READ ONLY"
  end
  return ""
end

local function modified_flag()
  if vim.bo.modified then
    return " +"
  end
  return ""
end

local function diagnostics()
  local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  if count > 0 then
    return string.format(" %%#VsvimStatusError# %d issues ", count)
  end
  return ""
end

function M.render()
  local mode = vim.api.nvim_get_mode().mode
  local label = mode_names[mode] or mode_names[mode:sub(1, 1)] or "EDIT"
  local mode_hl = mode_highlights[mode] or mode_highlights[mode:sub(1, 1)] or "VsvimStatusModeInsert"

  return table.concat({
    "%#VsvimStatusBase#",
    "%",
    "#",
    mode_hl,
    "# ",
    label,
    " ",
    "%#VsvimStatusBase#",
    " %<",
    filename(),
    modified_flag(),
    readonly_flag(),
    diagnostics(),
    "%=",
    "%#VsvimStatusMeta#",
    " %l:%c ",
    "%#VsvimStatusBase#",
    " %p%% ",
  })
end

function M.apply_highlights()
  local ok, palette = pcall(function()
    return require("vscode.colors").get_colors()
  end)

  if not ok then
    return
  end

  vim.api.nvim_set_hl(0, "VsvimStatusBase", {
    fg = palette.vscFront,
    bg = palette.vscPopupBack,
  })
  vim.api.nvim_set_hl(0, "VsvimStatusMeta", {
    fg = palette.vscLightBlue,
    bg = palette.vscPopupBack,
  })
  vim.api.nvim_set_hl(0, "VsvimStatusError", {
    fg = palette.vscDarkBlue,
    bg = palette.vscErrorForeground,
    bold = true,
  })
  vim.api.nvim_set_hl(0, "VsvimStatusModeNormal", {
    fg = palette.vscDarkBlue,
    bg = palette.vscLightBlue,
    bold = true,
  })
  vim.api.nvim_set_hl(0, "VsvimStatusModeInsert", {
    fg = palette.vscDarkBlue,
    bg = palette.vscLightGreen,
    bold = true,
  })
  vim.api.nvim_set_hl(0, "VsvimStatusModeVisual", {
    fg = palette.vscDarkBlue,
    bg = palette.vscMediumPurple,
    bold = true,
  })
  vim.api.nvim_set_hl(0, "VsvimStatusModeSelect", {
    fg = palette.vscDarkBlue,
    bg = palette.vscOrange,
    bold = true,
  })
  vim.api.nvim_set_hl(0, "VsvimStatusModeReplace", {
    fg = palette.vscDarkBlue,
    bg = palette.vscErrorForeground,
    bold = true,
  })
  vim.api.nvim_set_hl(0, "VsvimStatusModeCommand", {
    fg = palette.vscDarkBlue,
    bg = palette.vscYellow,
    bold = true,
  })
end

function M.setup()
  vim.o.statusline = "%!v:lua.require'utils.statusline'.render()"
  M.apply_highlights()

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("vsvim-statusline", { clear = true }),
    callback = function()
      vim.schedule(M.apply_highlights)
    end,
  })
end

return M
