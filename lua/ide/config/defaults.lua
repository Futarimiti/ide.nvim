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
               , other_actions = { config.other_actions, 'table' }
               , other_modes = { config.other_modes, 'table' }
               }
end

local defaults = { setups = { single = {}  -- core of the plugin - explained further in readme
                            , proj = {}
                            }
                 , quiet = false  -- UNUSED
                 , command = { enable = true  -- enable the command?
                             , name = 'IDE'  -- command name in one word; malformed command names may break things
                             }
                 , ui = { new = function ()  -- how would you like to bring up a new IDE terminal window?
                                  vim.cmd.vsplit()  -- default: vsplit
                                  return vim.api.nvim_get_current_win()  -- return window handle after you finish
                                end
                        , startinsert = true  -- enter insert mode after opening a new IDE terminal window?
                        , name = function (_) return 'IDE term' end  -- how should I name the IDE terminal window, given the buf handle of the file you're editing?
                        }
                 , write = { 'interpret', 'debug', 'run', 'build', 'repl_loaded', 'test', 'typecheck' }  -- the buffer will be written before these actions are run
                 , other_actions = {}  -- if you feel like standard actions are not enough, add your own here!
                 , other_modes = {}  -- ditto, though single and proj should suffice really
                 }

assert(pcall(typecheck, defaults))

return { defaults = defaults, typecheck = typecheck }
