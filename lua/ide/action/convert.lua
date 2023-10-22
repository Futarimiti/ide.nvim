-- an action input by user can be one of the following:
-- 1. a string with or without '%s' in it  -- interpolated and used as a command string
-- 2. fun(buf) -> command string           -- evaluated then interpolated and used as a command string
-- 3. fun(buf, dest-win)                   -- user can do whatever with the dest-win (note: ui.name will be overridden)
-- where we'll convert to this form:
-- fun(buf, prev_win) -> { new_win, new_buf }
local M = {}

local unload = function (prev_win, buf)
  if prev_win and vim.api.nvim_win_is_valid(prev_win) then
    vim.api.nvim_win_close(prev_win, true)
  end

  if buf and vim.api.nvim_buf_is_valid(buf) then
    vim.api.nvim_buf_delete(buf, { force = true })
  end
end

M.convert = function (user_conf, user_action)
  local startinsert = user_conf.ui.startinsert
  local new = user_conf.ui.new
  local name = user_conf.ui.name

  return function (buf, prev_win, prev_buf)
    unload(prev_win, prev_buf)
    local ide_win = assert(new(), 'ui.new must return a window handle')
    local ide_buf = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_win_set_buf(ide_win, ide_buf)

    local filename = vim.api.nvim_buf_call(buf, function () return vim.fn.expand '%:p:S' end)

    if type(user_action) == 'string' then
      local formatted_cmd = string.format(user_action, filename)
      vim.api.nvim_buf_call(ide_buf, function () vim.fn.termopen(formatted_cmd) end)
    else
      local result = user_action(buf, ide_win)
      if result then
        assert(type(result) == 'string', 'action return type must be a string')
        local formatted_cmd = string.format(result, filename)
        vim.api.nvim_buf_call(ide_buf, function () vim.fn.termopen(formatted_cmd) end)
      else
        return { ide_win, ide_buf }
      end
    end

    vim.api.nvim_buf_set_name(vim.api.nvim_win_get_buf(ide_win), name(buf))

    if startinsert then vim.api.nvim_win_call(ide_win, vim.cmd.startinsert) end
    return { ide_win, ide_buf }
  end
end

return M
