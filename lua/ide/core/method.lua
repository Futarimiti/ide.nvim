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
-- 3. a function that accepts a buffer id for the current buffer 
--    and another buffer id for the one to be opened in the new window,
--    specify what to be done on the new buffer.
--    Useful for functions like `feedkeys`.
---@alias user-method 
---| shell-command 
---| (fun(id: buf-id): shell-command) 
---| (fun(this: buf-id, new: buf-id))

local M = {}

-- convert user-method to method.
---@param user user-method
---@return method
M.from_user = function (user)
    ---@return win-id
    local new_vsplit = function ()
        vim.cmd.vsplit()
        local win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_option(win, 'number', false)
        vim.api.nvim_win_set_option(win, 'relativenumber', false)
        return win
    end

    ---@param str string
    local vsplit_term_buf = function (str)
        return function (buf_id)
            local filename = vim.api.nvim_buf_call(buf_id, function () return vim.fn.expand '%:p:S' end)
            local formatted = string.format(str, filename)
            local new_buf = vim.api.nvim_create_buf(true, true)
            vim.api.nvim_buf_call(new_buf, function () vim.fn.termopen(formatted) end)
            local win = new_vsplit()
            vim.api.nvim_win_set_buf(win, new_buf)
            vim.api.nvim_win_call(win, function () vim.cmd.startinsert() end)
            vim.api.nvim_buf_set_name(new_buf, 'IDE')
            return { new_buf }
        end
    end

    if type(user) == 'string' then
        return vsplit_term_buf(user)
    end

    -- inspect return type: nil or string
    return function (buf_id)  -- current buffer
        local new_buf = vim.api.nvim_create_buf(true, true)  -- term buf
        local win = new_vsplit()

        local ret = user(buf_id, new_buf)
        if ret == nil then
            vim.api.nvim_win_set_buf(win, new_buf)
            vim.api.nvim_win_call(win, function () vim.cmd.startinsert() end)
            vim.api.nvim_buf_set_name(new_buf, 'IDE')
            return { new_buf }
        else
            return vsplit_term_buf(ret)(buf_id)
        end
    end
end

return M
