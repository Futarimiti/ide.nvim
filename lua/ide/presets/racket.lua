-- You can also specify and pass in a racket language,
-- e.g. 'racket', 'r5rs' or 'scheme', etc.
-- Will look for the first '#lang' specification if none is provided.

local M = {}

local expand = function (buf_id, pat) return vim.api.nvim_buf_call(buf_id, function () return vim.fn.expand(pat) end) end

local empty_line = function (line) return line:match('^%s*$') ~= nil end
local is_comment = function (line) return line:match('^%s*%;') ~= nil end

local buf_get_lang = function (buf, silent)
  local notify = silent and function (...) end or vim.notify
  for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    local lang = line:match('^%s*#lang%s+(.-)%s*$')
    -- #lang declaration must be placed before any code
    -- if we already reached code, then there is no #lang
    local is_code = not (empty_line(line) or is_comment(line))
    if lang then
      notify('[ide] inferred racket dialect: ' .. lang, vim.log.levels.INFO)
      return lang
    elseif is_code then
      break
    end
  end

  notify('[ide] cannot infer racket dialect from buffer', vim.log.levels.WARN)
end

local racket_with_lang = function (lang, verbose)
  local get_lang = function (buf)
    return lang or buf_get_lang(buf, not verbose)
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
    vim.api.nvim_win_call(new, function ()
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

M.racket = racket_with_lang(nil, true)
setmetatable(M.racket, { __call = function (_, ...)
  local params = {...}
  local lang = params[1]
  local verbose = params[2]
  if verbose == nil then verbose = true end
  return racket_with_lang(lang, verbose) end
})

return M
