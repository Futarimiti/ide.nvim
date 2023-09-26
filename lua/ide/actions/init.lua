local A = require 'ide.core.action.actions'
local L = require 'ide.core.lib'

-- Perform a general action for the given buffer.
-- Upon failure of any reason, throw an error of the err msg.
---@param action action
---@param mode mode
---@param actions_set actions-set
---@return buf-id[]?
local general_action = function (buf_id, action, mode, actions_set)
    local should_save = A.should_save(action)
    ---@type ft
    local ft = vim.api.nvim_buf_get_option(buf_id, 'filetype')

    local ok, to_do = pcall(function (a) return a[mode][ft][action] end, actions_set)
    if not ok then
        error('[ide] An error raised in querying action: cannot find the *' .. tostring(action) .. '* action for filetype *' .. tostring(ft) .. '*')
    end

    if should_save then L.silent_write_buffer(buf_id) end
    local successful, res_or_err = pcall(to_do, buf_id)
    if successful then
        return res_or_err
    else
        error('[ide] An error raised in performing action *' .. tostring(action) .. '* for buffer *' .. tostring(buf_id) .. '*: ' .. res_or_err)
    end
end

local M = {}

for a, _ in pairs(A.action) do
    ---@param m mode
    M[a] = function (m, actions_set)
        local buf_id = vim.api.nvim_get_current_buf()
        return general_action(buf_id, a, m, actions_set)
    end
end

-- global var again
---@type buf-id[]
local last_bufs = {}

M.setup_command = function (cmd_name, actions_set)
    local f = function (opts)
        ---@type string[]
        local args = opts.fargs
        local action = args[1]
        local mode = args[2]
        local action_fun = M[action]
        if action_fun == nil then
            error('[ide] An error raised in parsing command *' .. tostring(cmd_name) .. '*: cannot find the *' .. tostring(action) .. '* action')
        end

        -- first delete buffers (if they exist) opened by the last action
        for _, buf in pairs(last_bufs) do
            if vim.api.nvim_buf_is_loaded(buf) then vim.api.nvim_buf_delete(buf, { force = true }) end
        end

        -- then perform the action and update last_bufs
        last_bufs = action_fun(mode, actions_set)
    end

    local opts = { nargs = '+' }

    vim.api.nvim_create_user_command(cmd_name, f, opts)
end

return M
