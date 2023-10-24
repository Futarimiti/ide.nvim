local M = {}

M.gen_complete = function (user)
  local cmdname = user.command.name
  local c = require 'ide.const'
  local std_actions = c.std_actions
  local other_actions = user.other_actions
  local std_modes = c.std_modes
  local other_modes = user.other_modes

  return function (_, line, _)
    local parsed = vim.api.nvim_parse_cmd(line, {})
    local cmd = parsed.cmd
    assert(cmd and cmd ~= '' and cmdname:match('^' .. cmd .. '.*$'))

    local n = #parsed.args
    assert(n >= 0)

    if n == 0 then
      return vim.tbl_flatten { std_actions, other_actions }
    elseif n == 1 then
      return vim.tbl_flatten { std_modes, other_modes }
    else
      return {}
    end
  end
end

return M
