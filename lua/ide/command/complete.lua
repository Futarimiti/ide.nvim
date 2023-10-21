local M = {}

M.gen_complete = function (user)
  local cmdname = user.command.name
  local c = require 'ide.const'
  local std_actions = c.std_actions
  local other_actions = user.other_actions
  local std_modes = c.std_modes
  local other_modes = user.other_modes

  return function (_, line, _)
    local args = (function ()
      local trimmed_head, _ = line:gsub('^%s+', '')
      local l = vim.split(trimmed_head, '%s+')
      assert(l[1] and l[1] ~= '' and cmdname:match('^' .. l[1] .. '.*$'))
      table.remove(l, 1)
      return l
    end)()

    local n = #args
    assert(n > 0)

    if n == 1 then
      return vim.tbl_flatten { std_actions, other_actions }
    elseif n == 2 then
      return vim.tbl_flatten { std_modes, other_modes }
    else
      return {}
    end
  end
end

return M
