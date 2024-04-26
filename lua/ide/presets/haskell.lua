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

return M
