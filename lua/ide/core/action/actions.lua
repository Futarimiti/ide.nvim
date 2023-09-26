local M = {}

---@enum action
local action =
{ build = 'build'
, interpret = 'interpret'
, run = 'run'
, exec = 'exec'
, debug = 'debug'
, repl = 'repl'
, repl_loaded = 'repl_loaded'
, test = 'test'
}

-- A set of ide actions. Not all of them are required!
-- * build: to build a file/project
-- * interpret: to interpret a file/project
-- * run: to build & run a file/project
-- * exec: to run a file/project without rebuild
-- * debug: to debug the current file/project
-- * repl: to run a REPL for this filetype
-- * repl_loaded: to run a REPL for this filetype, with the current file/project loaded
-- * test: to run tests for this file/project
---@alias actions table<action, method>
---@alias user-actions table<action, user-method>

M.action = action

-- Determine if the current file MUST be saved
-- before applying an action.
---@param a action
M.should_save = function (a)
    ---@type action[]
    local should = { action.build, action.interpret, action.run, action.debug, action.repl_loaded, action.test }
    return vim.tbl_contains(should, a)
end

return M

