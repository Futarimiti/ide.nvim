---@diagnostic disable-next-line: redundant-return-value
local expand = function (buf_id, pat) return vim.api.nvim_buf_call(buf_id, function () return vim.fn.expand(pat) end) end
local classname = function (buf_id) return expand(buf_id, '%:t:r:S') end

---@alias preset user-actions

local M = {}

M.fennel = { interpret = 'fennel %s'
           , repl = 'fennel --repl'
           , repl_loaded = 'fennel --load %s'
           }

M.scala = { interpret = 'scala %s'
          , repl = 'scala'
          , repl_loaded = function (this, new)
                            local file = expand(this, '%')
                            vim.api.nvim_buf_call(new, function ()
                                 vim.fn.termopen('scala')
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

M.xelatex = { repl = [[xelatex '\relax']]
            , build = 'xelatex %s'
            }

M.latexmk = { build = 'latexmk -g %s'
            , interpret = 'latexmk -pv %s'
            , debug = 'latexmk -pvc %s'
            }

M.idris = { repl = 'idris'
          , repl_loaded = 'idris %s'
          }

M.idris2 = { repl = 'idris2'
           , repl_loaded = 'idris2 %s'
           }

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
---@type preset
M.python = python_with_version ''
setmetatable(M.python, { __call = function (_, ver) return python_with_version(ver) end })

local racket_with_lang = function (lang)
  local lang_flag = lang and ' -I ' .. lang or ''
  local racket = 'racket' .. lang_flag
  return { interpret = racket .. ' %s'
         , repl = racket .. ' -i'
         , repl_loaded = function (this, new)
             local pt = expand(this, '%:p:t')
             local phS = expand(this, '%:p:h:S')
             vim.api.nvim_buf_call(new, function ()
               vim.fn.termopen('cd '.. phS .. '; ' .. racket .. ' -i')
               vim.cmd.startinsert()
               vim.api.nvim_input(',enter "' .. pt .. '"<CR>')
             end)
           end
         }
end

-- You can also specify and pass in a racket language,
-- e.g. 'racket', 'r5rs' or 'scheme', etc.
M.racket = racket_with_lang(nil)
setmetatable(M.racket, { __call = function (_, lang) return racket_with_lang(lang) end })

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
