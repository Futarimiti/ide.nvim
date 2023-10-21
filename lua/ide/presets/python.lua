local M = {}

M.ptpython = { interpret = 'ptpython %s'
             , repl = 'ptpython'
             , repl_loaded = 'ptpython -i %s'
             }

local python_with_version = function (ver)
    local v = ver and tostring(ver) or ''
    return { interpret = 'python' .. v .. ' %s'
           , debug = 'python' .. v .. ' -m pdb %s'
           , repl = 'python' .. v
           , repl_loaded = 'python' .. v .. ' -i %s'
           }
end

-- You can also pass in a number or a string, e.g. 3.12 or '3.12'
-- as the version of python you want to use,
-- using metatable magic.
-- example: python(3.12) --> { build = 'python3.12 -m py_compile %s', ... }
M.python = python_with_version ''
setmetatable(M.python, { __call = function (_, ver) return python_with_version(ver) end })

return M
