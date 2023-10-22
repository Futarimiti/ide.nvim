local M = {}

-- updated during runtime
local global = {}

M.init_global = function (user)
  global = user.setups
end

M.put = function (mode, ft, action, procedure)
  if not global[mode] then
    global[mode] = {}
  end
  if not global[mode][ft] then
    global[mode][ft] = {}
  end
  global[mode][ft][action] = procedure
end

M.get = function (mode, ft, action)
  return vim.tbl_get(global, mode, ft, action)
end

return M
