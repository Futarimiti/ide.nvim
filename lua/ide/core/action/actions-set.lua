---@diagnostic disable: assign-type-mismatch
local mode = require('ide.core.mode').mode
local Method = require 'ide.core.method'

local M = {}

---@alias actions-set table<mode, table<ft, table<action, method>>>
---@alias user-actions-set table<mode, table<ft, table<action, user-method>>>

-- Convert user-actions-set to actions-set.
---@param user user-actions-set
---@return actions-set
M.from_user = function (user)
    local map = function (f)
        return function (tbl)
            return vim.tbl_map(f, tbl)
        end
    end

    return map(map(map(Method.from_user)))(user)
end

-- An empty initial actions set.
---@type actions-set
M.empty = { [mode.single] = {}, [mode.project] = {} }

-- -- Add some actions for a filetype.
-- -- Will override existing impl if necessary.
-- ---@param actions_set actions-set
-- ---@param m mode
-- ---@param ft ft
-- ---@param entry table<action, method>
-- ---@return actions-set
-- M.add_ft_actions = function (actions_set, m, ft, entry)
--     local prev = actions_set[m][ft]
--     local new = vim.tbl_deep_extend('keep', entry, prev)
--     ---@type actions-set
--     local copy = vim.fn.deepcopy(actions_set)
--     copy[m][ft] = new
--     return copy
-- end

-- M.set_ft_actions = M.add_ft_actions

-- ---@param actions_set actions-set
-- ---@param m mode
-- ---@param ft ft
-- M.del_ft = function (actions_set, m, ft)
--     ---@type actions-set
--     local copy = vim.fn.deepcopy(actions_set)
--     copy[m][ft] = nil
--     return copy
-- end

-- ---@param actions_set actions-set
-- ---@param m mode
-- ---@param ft ft
-- ---@param action action
-- M.del_ft_action = function (actions_set, m, ft, action)
--     ---@type actions-set
--     local copy = vim.fn.deepcopy(actions_set)
--     copy[m][ft][action] = nil
--     return copy
-- end

return M
