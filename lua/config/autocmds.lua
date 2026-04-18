local M = {}

local disabled_filetypes = {
  ["TelescopePrompt"] = true,
  ["checkhealth"] = true,
  ["help"] = true,
  ["lazy"] = true,
  ["mason"] = true,
  ["noice"] = true,
  ["qf"] = true,
  ["snacks_dashboard"] = true,
  ["snacks_input"] = true,
  ["snacks_notif"] = true,
  ["snacks_picker_input"] = true,
}

local function is_editable_buffer(bufnr)
  local bo = vim.bo[bufnr]
  return bo.buftype == ""
    and bo.buflisted
    and bo.modifiable
    and not disabled_filetypes[bo.filetype]
end

local function reenter_insert(bufnr)
  vim.schedule(function()
    if not vim.api.nvim_buf_is_valid(bufnr) then
      return
    end
    if vim.api.nvim_get_current_buf() ~= bufnr then
      return
    end
    if not is_editable_buffer(bufnr) then
      return
    end
    if vim.g.vsvim_suspend_insert_guard then
      return
    end
    if vim.fn.mode() == "n" then
      vim.cmd("startinsert")
    end
  end)
end

M.setup = function()
  local group = vim.api.nvim_create_augroup("vsvim", { clear = true })

  vim.api.nvim_create_autocmd("TextYankPost", {
    group = group,
    callback = function()
      vim.highlight.on_yank({ timeout = 120 })
    end,
  })

  vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "VimEnter" }, {
    group = group,
    callback = function(args)
      reenter_insert(args.buf)
    end,
  })

  vim.api.nvim_create_autocmd("InsertLeave", {
    group = group,
    callback = function(args)
      reenter_insert(args.buf)
    end,
  })
end

return M
