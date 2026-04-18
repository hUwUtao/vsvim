local M = {}

local helper = require("utils.accessibility")

local function map(modes, lhs, rhs, desc)
  vim.keymap.set(modes, lhs, rhs, { desc = desc, silent = true })
end

local function expr_map(modes, lhs, rhs, desc)
  vim.keymap.set(modes, lhs, rhs, { desc = desc, expr = true, silent = true })
end

M.setup = function()
  map({ "n", "i", "v", "s" }, "<C-s>", helper.save, "Save")
  map({ "n", "i", "v", "s" }, "<C-q>", helper.quit, "Quit")

  map({ "n", "i", "v", "s" }, "<C-p>", helper.command_palette, "Command Palette")
  map({ "n", "i", "v", "s" }, "<C-S-p>", helper.command_palette, "Command Palette")

  map({ "n", "i", "v", "s" }, "<C-f>", helper.search_in_buffer, "Search")
  map("n", "<C-h>", helper.replace_in_buffer, "Replace")
  map({ "n", "i", "v", "s" }, "<C-r>", helper.replace_in_buffer, "Replace")
  map({ "n", "i", "v", "s" }, "<C-z>", helper.undo, "Undo")
  map({ "n", "i", "v", "s" }, "<C-y>", helper.redo, "Redo")

  map({ "n", "i", "v", "s" }, "<C-b>", helper.browse_files, "Files")
  map({ "n", "i", "v", "s" }, "<C-S-f>", helper.search_in_project, "Project Search")

  map("i", "<C-v>", helper.insert_paste, "Paste")

  map("x", "<BS>", helper.delete_selection, "Delete Selection")
  map("x", "<C-h>", helper.delete_selection, "Delete Selection")
  map("x", "<Del>", helper.delete_selection, "Delete Selection")
  map("x", "<C-c>", helper.copy_selection, "Copy Selection")
  map("x", "<C-x>", helper.cut_selection, "Cut Selection")
  map("x", "<C-v>", helper.replace_selection_with_clipboard, "Paste")

  map("n", "<C-c>", helper.copy_line, "Copy Line")
  map("i", "<C-c>", helper.copy_line, "Copy Line")
  map("n", "<C-x>", helper.cut_line, "Cut Line")
end

return M
