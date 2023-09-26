---@diagnostic disable-next-line: redundant-return-value
local classname = function (buf_id) return vim.api.nvim_buf_call(buf_id, function () return vim.fn.expand '%:t:r:S' end) end

---@alias preset user-actions

local M = {}

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
