local M = {}

-- returns complete, valid user config
-- or panic with illegal config
M.validate = function (raw)
  local user = raw or {}
  vim.validate { user_config = { user, 'table' } }

  local d = require('ide.config.defaults')
  local defaults = d.defaults
  local typecheck = d.typecheck
  local updated = vim.tbl_deep_extend('keep', user, defaults)
  typecheck(updated)

  return updated
end

return M
