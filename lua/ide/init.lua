local M = {}

M.setup = function (raw)
  local config = require 'ide.config'
  local command = require 'ide.command'
  local action = require 'ide.action'

  local user = config.validate(raw)

  action.init_global(user)
  command.setup_commands(user)
end

return M
