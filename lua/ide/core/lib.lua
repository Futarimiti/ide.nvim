local M = {}

-- Try to silently write a buffer.
-- Upon failure, throw an error of the err msg.
---@param buf_id integer
M.silent_write_buffer = function (buf_id)
    local silent_write = function ()
        vim.api.nvim_cmd({cmd='update', mods={silent=true}}, {})
    end
    local successful, errmsg = pcall(vim.api.nvim_buf_call, buf_id, silent_write)
    if not successful then
        error('[ide] An error raised in writing the current buffer: ' .. errmsg)
    end
end

-- Drop a buffer.
---@param buf_id buf-id
M.drop_buffer = function (buf_id)
    vim.api.nvim_buf_delete(buf_id, { force = true })
end

M.id = function (x) return x end

return M
