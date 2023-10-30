local M = {}

local expand = function (buf_id, pat) return vim.api.nvim_buf_call(buf_id, function () return vim.fn.expand(pat) end) end

M.racket = require('ide.presets.racket').racket

M.glow = { interpret = 'glow %s' }

M.mdless = { interpret = 'mdless -P %s 2> /dev/null' }

local chez = function (cmd)
  return { interpret = cmd .. ' --script %s'
         , repl_loaded = cmd .. ' %s'
         , repl = cmd
         }
end

M.chez_scheme = chez 'scheme'
M.chez_petite = chez 'petite'

M.mojo = { interpret = 'mojo run %s'
         , repl = 'mojo repl'
         , build = 'mojo build %s'
         , debug = 'mojo debug'
         }

M.fennel = { interpret = 'fennel %s'
           , repl = 'fennel --repl'
           , repl_loaded = 'fennel --load %s'
           }

M.rlwrap_fennel = { repl = 'rlwrap fennel --repl'
                  , repl_loaded = 'rlwrap fennel --load %s'
                  }

M.scala = { interpret = 'scala %s'
          , repl = 'scala'
          , repl_loaded = function (this, new)
                            local file = expand(this, '%')
                            vim.api.nvim_buf_call(new, function ()
                                 vim.fn.termopen 'scala'
                                 vim.cmd.startinsert()
                                 vim.api.nvim_input(':load ' .. file .. '<CR>')
                            end)
                          end
          }

-- evcxr does not support loading files
M.evcxr = { repl = 'evcxr' }

M.cargo = { build = 'cargo build'
          , run = 'cargo run'
          , test = 'cargo test'
          }

local tex = function (lang)
  return { repl = lang .. [[ '\relax']]
         , build = lang .. ' %s'
         }
end

M.tex = tex 'tex'
M.pdftex = tex 'pdftex'
M.pdflatex = tex 'pdflatex'
M.xelatex = tex 'xelatex'

M.latexmk = { build = 'latexmk -g %s'
            , interpret = 'latexmk -pv %s'
            , debug = 'latexmk -pvc %s'
            }

local idris = require 'ide.presets.idris'
M.idris = idris.idris
M.idris2 = idris.idris2

M.ptpython = require('ide.presets.python').ptpython
M.python = require('ide.presets.python').python

M.lua = { interpret = 'lua %s'
        , build = 'luac %s'
        , repl = 'lua'
        , repl_loaded = 'lua -i %s'
        }

local java = require 'ide.presets.java'

M.java = java.java
M.java_preview = java.java_preview
M.maven = java.maven

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

return M
