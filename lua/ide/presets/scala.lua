local expand = function (buf_id, pat) return vim.api.nvim_buf_call(buf_id, function () return vim.fn.expand(pat) end) end
local M = {}

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

M.sbt = { run = 'sbt run'
        , repl_loaded = 'sbt console'
        , build = 'sbt compile'
        , test = 'sbt test'
        , debug = 'sbt run --debug'
        }

return M
