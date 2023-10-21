-- for user convenience (doing keymaps, etc)

local M = {}

M.setup_actions = function (user)
  local std_actions = require('ide.const').std_actions
  local std_modes = require('ide.const').std_modes
  local other_actions = user.other_actions
  local other_modes = user.other_modes

  local actions = vim.tbl_flatten { std_actions, other_actions }
  local modes = vim.tbl_flatten { std_modes, other_modes }

  local op = function (mode, action)
    return function ()
      local operate = require('ide.action').operate
      local win = vim.api.nvim_get_current_win()
      operate(user, win, mode, action)
    end
  end

  for _, mode in ipairs(modes) do
    M[mode] = M[mode] or {}
    for _, action in ipairs(actions) do
      M[mode][action] = op(mode, action)
    end
  end
end

return M
