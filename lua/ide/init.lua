local M = {}

local A = require 'ide.actions'
local ASet = require 'ide.core.action.actions-set'
local Opts = require 'ide.opts'

local cmd_name = 'IDE'

-- I HATE GLOBAL VARIABLES
local global_actions_set = ASet.empty

---@param opts opts
M.setup = function (opts)
    -- update global actions set
    local user_actions_set = Opts.get_user_actions_set(opts)
    local normal_actions_set = ASet.from_user(user_actions_set)
    global_actions_set = vim.tbl_deep_extend('keep', normal_actions_set, global_actions_set)

    -- setup command & update global last_bufs
    local has_command = (vim.api.nvim_get_commands { builtin = false })[cmd_name] ~= nil
    if has_command then vim.api.nvim_del_user_command(cmd_name) end
    A.setup_command(cmd_name, global_actions_set)
end

return M
