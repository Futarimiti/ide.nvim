local M = {}

M.setup = function (raw)
  local config = require 'ide.config'
  local command = require 'ide.command'
  local action = require 'ide.action'
  local user_ = require 'ide.user'

  local user = config.validate(raw)

  action.init_global(user)
  user_.setup_actions(user)
  command.setup_commands(user)
end

return M
