local M = {}

local expand = function (buf_id, pat) return vim.api.nvim_buf_call(buf_id, function () return vim.fn.expand(pat) end) end

local empty_line = function (line) return line:match('^%s*$') ~= nil end
local is_comment = function (line) return line:match('^%s*%;') ~= nil end

local buf_get_lang = function (buf)
  for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    local lang = line:match('^%s*#lang%s+(.-)%s*$')
    -- #lang declaration must be placed before any code
    -- if we already reached code, then there is no #lang
    local is_code = not (empty_line(line) or is_comment(line))
    if lang then
      vim.notify('[ide] inferred racket dialect: ' .. lang, vim.log.levels.INFO)
      return lang
    elseif is_code then
      break
    end
  end

  vim.notify('[ide] cannot infer racket dialect from buffer', vim.log.levels.WARN)
end

local racket_with_lang = function (lang)
  local get_lang = function (buf)
    return lang or buf_get_lang(buf)
  end

  local append_lang_flag = function (buf, cmd)
    local lang_ = get_lang(buf)
    local lang_flag = lang_ and ' -I ' .. lang_ or ''
    return cmd .. lang_flag
  end

  local get_cmd = function (buf)
    return append_lang_flag(buf, 'racket')
  end

  local interpret = function (buf) return get_cmd(buf) .. ' %s' end
  local repl = function (buf) return get_cmd(buf) .. ' -i' end
  local repl_loaded = function (this, new)
    local pt = expand(this, '%:p:t')
    local phS = expand(this, '%:p:h:S')
    vim.api.nvim_buf_call(new, function ()
      vim.fn.termopen('cd '.. phS .. '; ' .. get_cmd(this) .. ' -i')
      vim.cmd.startinsert()
      vim.api.nvim_input(',enter "' .. pt .. '"<CR>')
    end)
  end

  return { interpret = interpret
         , repl = repl
         , repl_loaded = repl_loaded
         }
end

local racket = racket_with_lang(nil)
setmetatable(racket, { __call = function (_, lang) return racket_with_lang(lang) end })

M.racket = racket

return M
