local M = {}

local function feed(keys, mode)
  local termcodes = vim.api.nvim_replace_termcodes(keys, true, false, true)
  vim.api.nvim_feedkeys(termcodes, mode or "n", false)
end

local function in_insert_mode()
  local mode = vim.fn.mode()
  return mode == "i" or mode == "ic"
end

local function safe_require(module)
  local ok, value = pcall(require, module)
  if ok then
    return value
  end
end

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = "vsvim" })
end

local startinsert_if_needed

local function suspend_insert_guard()
  vim.g.vsvim_suspend_insert_guard = true
end

local function resume_insert_guard()
  vim.g.vsvim_suspend_insert_guard = false
end

local function get_active_selection_text()
  local chunks = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), {
    type = vim.fn.mode(),
  })
  return table.concat(chunks, "\n")
end

local function escape_pattern(text)
  return vim.fn.escape(text, [[\/]])
end

local function escape_replacement(text)
  return text:gsub("\\", "\\\\"):gsub("/", "\\/"):gsub("&", "\\&")
end

startinsert_if_needed = function()
  if not in_insert_mode() and vim.bo.buftype == "" then
    vim.cmd("startinsert")
  end
end

function M.save()
  vim.cmd("silent write")
  startinsert_if_needed()
end

function M.quit()
  suspend_insert_guard()
  vim.cmd("confirm qall")
end

function M.command_palette()
  local snacks = safe_require("snacks")
  if snacks and snacks.picker then
    suspend_insert_guard()
    if in_insert_mode() then
      vim.cmd("stopinsert")
    end
    vim.schedule(function()
      local active_snacks = safe_require("snacks")
      if active_snacks and active_snacks.picker then
        active_snacks.picker.commands()
      end
      vim.schedule(resume_insert_guard)
    end)
    return
  end
  notify("Command palette is not available yet.", vim.log.levels.WARN)
end

function M.browse_files()
  local snacks = safe_require("snacks")
  if snacks and snacks.picker then
    suspend_insert_guard()
    if in_insert_mode() then
      vim.cmd("stopinsert")
    end
    vim.schedule(function()
      local active_snacks = safe_require("snacks")
      if active_snacks and active_snacks.picker then
        active_snacks.picker.smart()
      end
      vim.schedule(resume_insert_guard)
    end)
    return
  end
  notify("File browser is not available yet.", vim.log.levels.WARN)
end

function M.search_in_buffer()
  local snacks = safe_require("snacks")
  if snacks and snacks.picker then
    suspend_insert_guard()
    if in_insert_mode() then
      vim.cmd("stopinsert")
    end
    vim.schedule(function()
      local active_snacks = safe_require("snacks")
      if active_snacks and active_snacks.picker then
        active_snacks.picker.lines()
      end
      vim.schedule(resume_insert_guard)
    end)
    return
  end
  feed("/")
end

function M.search_in_project()
  local snacks = safe_require("snacks")
  if snacks and snacks.picker then
    suspend_insert_guard()
    if in_insert_mode() then
      vim.cmd("stopinsert")
    end
    vim.schedule(function()
      local active_snacks = safe_require("snacks")
      if active_snacks and active_snacks.picker then
        active_snacks.picker.grep()
      end
      vim.schedule(resume_insert_guard)
    end)
    return
  end
  notify("Project search is not available yet.", vim.log.levels.WARN)
end

function M.replace_in_buffer()
  suspend_insert_guard()
  vim.ui.input({ prompt = "Find text: " }, function(find_text)
    if not find_text or find_text == "" then
      resume_insert_guard()
      startinsert_if_needed()
      return
    end

    vim.ui.input({ prompt = "Replace with: " }, function(replace_text)
      if replace_text == nil then
        resume_insert_guard()
        startinsert_if_needed()
        return
      end

      local command = ("%%s/%s/%s/gc"):format(
        escape_pattern(find_text),
        escape_replacement(replace_text)
      )

      local ok, err = pcall(vim.cmd, command)
      if not ok then
        notify(err, vim.log.levels.ERROR)
      end
      resume_insert_guard()
      startinsert_if_needed()
    end)
  end)
end

function M.undo()
  if in_insert_mode() then
    feed("<Esc>u", "n")
    feed("a", "n")
    return
  end
  vim.cmd("undo")
  startinsert_if_needed()
end

function M.redo()
  if in_insert_mode() then
    feed("<Esc><C-r>", "n")
    feed("a", "n")
    return
  end
  vim.cmd("redo")
  startinsert_if_needed()
end

function M.insert_paste()
  vim.api.nvim_paste(vim.fn.getreg("+"), true, -1)
end

function M.replace_selection_with_clipboard()
  vim.fn.setreg('"', vim.fn.getreg("+"))
  vim.cmd([[normal! "_dP]])
  startinsert_if_needed()
end

function M.delete_selection()
  vim.cmd([[normal! "_d]])
  startinsert_if_needed()
end

function M.copy_selection()
  local text = get_active_selection_text()
  vim.fn.setreg("+", text)
  startinsert_if_needed()
end

function M.cut_selection()
  local text = get_active_selection_text()
  vim.fn.setreg("+", text)
  vim.cmd([[normal! "_d]])
  startinsert_if_needed()
end

function M.copy_line()
  vim.fn.setreg("+", vim.api.nvim_get_current_line())
  notify("Copied current line.")
  startinsert_if_needed()
end

function M.cut_line()
  local line = vim.api.nvim_get_current_line()
  vim.fn.setreg("+", line)
  vim.cmd("normal! dd")
  startinsert_if_needed()
end

return M
