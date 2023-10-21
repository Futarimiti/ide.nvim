local M = {}

M.gen_complete = function (user)
  local cmdname = user.command.name
  return function (_, line, _)
    local args = (function ()
      local trimmed_head, _ = line:gsub('^%s+', '')
      local l = vim.split(trimmed_head, '%s+')
      assert(l[1] and l[1] ~= '' and cmdname:match('^' .. l[1] .. '.*$'))
      table.remove(l, 1)
      return l
    end)()

    print('args: ' .. vim.inspect(args))

    local n = #args
    assert(n > 0)

    local c = require 'ide.const'
    if n == 1 then
      return c.std_actions
    elseif n == 2 then
      return c.std_modes
    else
      return {}
    end
  end
end

return M
