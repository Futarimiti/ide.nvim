local M = {}

M.ghc = { build = 'ghc --make %s'
        , interpret = 'runghc %s'
        , repl = 'ghci'
        , repl_loaded = 'ghci %s'
        }

M.cabal = { build = 'cabal build'
          , run = 'cabal run'
          , exec = 'cabal exec'
          , repl_loaded = 'cabal repl'
          , test = 'cabal test'
          }

M.stack = { build = 'stack build'
          , run = 'stack run'
          , repl_loaded = 'stack ghci'
          , test = 'stack test'
          }

-- using a particular resolver
---@param resolver string
local stack = function (resolver)
  if resolver == nil or resolver == '' then
    return { build = 'stack build'
           , run = 'stack run'
           , repl_loaded = 'stack ghci'
           , test = 'stack test'
           , interpret = 'stack %s'
           }
  else
    return { build = 'stack build --resolver ' .. resolver
           , run = 'stack run --resolver ' .. resolver
           , repl_loaded = 'stack ghci --resolver ' .. resolver
           , test = 'stack test --resolver ' .. resolver
           , interpret = 'stack script --resolver ' .. resolver .. ' %s'
           }
  end
end

setmetatable(M.stack, { __call = function (_, resolver) return stack(resolver) end })

return M
