-- for user convenience (doing keymaps, etc)

local M = {}

M.single = {}
M.proj = {}

local later = function ()
  error 'Not yet instantiated!'
end

M.single.build = later
M.single.interpret = later
M.single.run = later
M.single.exec = later
M.single.debug = later
M.single.repl = later
M.single.repl_loaded = later
M.single.test = later
M.proj.build = later
M.proj.interpret = later
M.proj.run = later
M.proj.exec = later
M.proj.debug = later
M.proj.repl = later
M.proj.repl_loaded = later
M.proj.test = later

M.setup_actions = function (user)
  local op = function (mode, action)
    return function ()
      local operate = require('ide.action').operate
      local win = vim.api.nvim_get_current_win()
      operate(user, win, mode, action)
    end
  end

  M.single.build = op('single', 'build')
  M.single.interpret = op('single', 'interpret')
  M.single.run = op('single', 'run')
  M.single.exec = op('single', 'exec')
  M.single.debug = op('single', 'debug')
  M.single.repl = op('single', 'repl')
  M.single.repl_loaded = op('single', 'repl_loaded')
  M.single.test = op('single', 'test')
  M.proj.build = op('proj', 'build')
  M.proj.interpret = op('proj', 'interpret')
  M.proj.run = op('proj', 'run')
  M.proj.exec = op('proj', 'exec')
  M.proj.debug = op('proj', 'debug')
  M.proj.repl = op('proj', 'repl')
  M.proj.repl_loaded = op('proj', 'repl_loaded')
  M.proj.test = op('proj', 'test')

end

return M
