local M = {}

M.setup_commands = function (user)
  if not user.command.enable then return end

  local name = user.command.name

  vim.api.nvim_create_user_command(name, function (args)
    local win = vim.api.nvim_get_current_win()
    local action = args.fargs[1]
    local mode = args.fargs[2]
    require('ide.action').operate(win, mode, action)
  end, { nargs = '+' })
end

return M
