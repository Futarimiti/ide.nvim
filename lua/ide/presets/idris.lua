local M = {}

local _idris = function (banner)
  local b = banner and '' or '--nobanner'
  return
    { repl = 'idris ' .. b
    , repl_loaded = 'idris ' .. b .. ' %s'
    , typecheck = 'idris --check %s'
    , interpret = 'idris --execute main %s'
    }
end

local _idris2 = function (rlwrap, banner)
  local r = rlwrap and 'rlwrap' or ''
  local b = banner and '' or '--nobanner'
  return
    { repl = r .. ' idris2 ' .. b
    , repl_loaded = r .. ' idris2 ' .. b .. ' %s'
    , typecheck = 'idris2 --check %s'
    , run = 'idris2 --exec main %s'
    }
end

-- default behaviour
local idris = _idris(true)
local idris2 = _idris2(false, true)

setmetatable(idris, { __call = function (_, banner) return _idris(banner) end })
setmetatable(idris2, { __call = function (_, rlwrap, banner) return _idris2(rlwrap, banner) end })

M.idris = idris
M.idris2 = idris2

return M
