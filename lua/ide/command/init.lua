local M = {}

M.setup_commands = function (user)
  if not user.command.enable then return end

  local name = user.command.name

  vim.api.nvim_create_user_command(name, function (args)
    local win = vim.api.nvim_get_current_win()
    local action = args.fargs[1]
    local mode = assert(args.fargs[2], 'Missing mode')
    require('ide.action').operate(user, win, mode, action)
  end, { nargs = '+', complete = require('ide.command.complete').gen_complete(user) })
end

return M
