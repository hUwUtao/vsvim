local M = {}

function M.source(repo)
  local name = repo:match("/([^/]+)$") or repo
  local local_dir = vim.fn.stdpath("config") .. "/vendor/" .. name

  if vim.uv.fs_stat(local_dir) then
    return local_dir
  end

  return repo
end

return M
