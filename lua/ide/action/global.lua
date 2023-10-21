local M = {}

-- updated during runtime
local global = {}

M.init_global = function (user)
  -- local convert_all = require('ide.action.convert').convert_all
  -- global = convert_all(user, user.setups)
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
  local g_mode = global[mode]
  if g_mode then
    local g_ft = g_mode[ft]
    if g_ft then
      return g_ft[action]
    end
  end
  return nil
end

return M
