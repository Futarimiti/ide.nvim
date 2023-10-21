local typecheck = function (config)
  vim.validate { setups = { config.setups, 'table' }
               , ['setups.single'] = { config.setups.single, 'table' }
               , ['setups.proj'] = { config.setups.proj, 'table' }
               , quiet = { config.quiet, 'boolean' }
               , command = { config.command, 'table' }
               , ['command.enable'] = { config.command.enable, 'boolean' }
               , ['command.name'] = { config.command.name, 'string' }
               , ui = { config.ui, 'table' }
               , ['ui.new'] = { config.ui.new, 'function' }
               , ['ui.startinsert'] = { config.ui.startinsert, 'boolean' }
               , ['ui.name'] = { config.ui.name, 'function' }
               , write = { config.write, 'table' }
               }
end

local defaults = { setups = { single = {}
                            , proj = {}
                            }
                 , quiet = false
                 , command = { enable = true
                             , name = 'IDE'
                             }
                 , ui = { new = function ()
                                  vim.cmd.vsplit()
                                  return vim.api.nvim_get_current_win()
                                end
                        , startinsert = true
                        , name = function (_) return 'IDE term' end
                        }
                 , write = { 'interpret', 'debug', 'run', 'build', 'repl_loaded', 'test' }
                 }

assert(pcall(typecheck, defaults))

return { defaults = defaults, typecheck = typecheck }
