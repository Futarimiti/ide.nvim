local M = {}

local get = require('ide.action.global').get
local init_global = require('ide.action.global').init_global

M.init_global = init_global

local prev_ide_win = nil

-- stolen from SICP ;)
M.operate = function (win, mode, action)
  local buf = vim.api.nvim_win_get_buf(win)
  assert(buf, 'No buffer found within current window')

  local ft = vim.filetype.match { buf = buf }
  assert(ft, 'Cannot detect filetype for current buffer')

  local procedure = get(mode, ft, action)
  assert(procedure, string.format('No procedure found: %s, %s, %s', mode, ft, action))

  prev_ide_win = procedure(buf, prev_ide_win)
end

return M
