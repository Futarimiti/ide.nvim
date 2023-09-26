---@diagnostic disable-next-line: redundant-return-value
local classname = function (buf_id) return vim.api.nvim_buf_call(buf_id, function () return vim.fn.expand '%:t:r:S' end) end

---@alias preset user-actions

local M = {}

local python_with_version = function (v)
    return { build = 'python' .. v .. ' -m py_compile %s'
           , interpret = 'python' .. v .. ' %s'
           , debug = 'python' .. v .. ' -m pdb %s'
           , repl = 'python' .. v
           , repl_loaded = 'python' .. v .. ' -i %s'
           }
end

-- You can also pass in a number or a string, e.g. 3.12 or '3.12'
-- as the version of python you want to use,
-- using metatable magic.
-- example: python(3.12) --> { build = 'python3.12 -m py_compile %s', ... }
---@type preset
M.python = python_with_version ''

setmetatable(M.python, { __call = python_with_version })

M.lua = { interpret = 'lua %s'
        , build = function (id) return 'luac -o ' .. classname(id) .. ' %s' end
        , repl = 'lua'
        , repl_loaded = 'lua -i %s'
        }

-- single java file
---@type preset
M.java = { build = 'javac %s'
         , interpret = 'java %s'
         , debug = function (id) return 'jdb ' .. classname(id) end
         , repl = 'jshell'
         , repl_loaded = 'jshell %s'
         }

-- maven for java projects
---@type preset
M.maven = { build = 'mvn compile'
          , run = 'mvn exec:java'
          , test = 'mvn test'
          }

-- ghc for haskell (single file)
---@type preset
M.ghc = { build = 'ghc --make %s'
        , interpret = 'runhaskell %s'
        , repl = 'ghci'
        , repl_loaded = 'ghci %s'
        }

-- cabal for haskell projects
---@type preset
M.cabal = { build = 'cabal build'
          , run = 'cabal run'
          , exec = 'cabal exec'
          , repl_loaded = 'cabal repl'
          , test = 'cabal test'
          }

return M
