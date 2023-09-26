---@diagnostic disable: redundant-return-value
-- Specifying how to perform one ide action
-- on the given buffer.
-- Returns a set of buffer ids 
-- for buffers that have been opened during this action
-- that should be closed when done.
---@alias method fun(buf-id): buf-id[]

-- Adapted for user input
-- It can be one of the following:
-- 1. a shell command. `'%s'` may be added to substitute for filename.
-- 2. a recipe for a shell command, given the buffer handle. `'%s'` will be interpolated.
-- 3. a method
---@alias user-method 
---| shell-command 
---| (fun(id: buf-id): shell-command) 
---| method

local M = {}

-- convert user-method to method.
---@param user user-method
---@return method
M.from_user = function (user)
    ---@param str string
    local vsplit_term_buf = function (str)
        return function (buf_id)
            local filename = vim.api.nvim_buf_call(buf_id, function () return vim.fn.expand '%:p:S' end)
            local formatted = string.format(str, filename)
            local new_buf = vim.api.nvim_create_buf(true, true)
            vim.api.nvim_buf_call(new_buf, function () vim.ft.termopen(formatted) end)
            vim.cmd.vsplit()
            local win = vim.api.nvim_get_current_win()
            vim.api.nvim_win_set_buf(win, new_buf)
            return { new_buf }
        end
    end

    if type(user) == 'string' then
        return vsplit_term_buf(user)
    end

    -- inspect return type
    return function (buf_id)
        local ret = user(buf_id)
        if type(ret) == 'string' then
            return vsplit_term_buf(ret)(buf_id)
        else
            return ret
        end
    end
end

return M
