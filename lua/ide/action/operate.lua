local M = {}

local get = require('ide.action.global').get
local prev_ide_win = nil
local prev_ide_buf = nil

-- stolen from SICP ;)
local op = function (user, buf, mode, action)
  local notify = function (...)
    if user.quiet then return end
    vim.notify(...)
  end

  assert(buf, 'No buffer found within current window')

  local ft = (function ()
    local buf_ft = vim.api.nvim_buf_get_option(buf, 'filetype')
    if buf_ft ~= '' then return buf_ft end
    notify('[ide] Cannot find filetype for current buffer, trying to detect', vim.log.levels.INFO)
    local detected, _ = vim.filetype.match { buf = buf }
    return detected
  end)()
  assert(ft, 'Cannot detect filetype for current buffer')

  local procedure = get(mode, ft, action)
  assert(procedure, string.format('No procedure found: %s, %s, %s', mode, ft, action))

  return procedure
end

M.operate = function (user, win, mode, action)
  local buf = vim.api.nvim_win_get_buf(win)
  local procedure = op(user, buf, mode, action)

  if vim.tbl_contains(user.write, action) then
    vim.api.nvim_buf_call(buf, vim.cmd.update)
  end

  local convert = require('ide.action.convert').convert

  local new_ids = convert(user, procedure)(buf, prev_ide_win, prev_ide_buf)
  prev_ide_win = new_ids[1]
  prev_ide_buf = new_ids[2]
end

return M
