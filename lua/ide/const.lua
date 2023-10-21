local M = {}

M.std_actions = { 'build'
                , 'interpret'
                , 'run'
                , 'exec'
                , 'debug'
                , 'repl'
                , 'repl_loaded'
                , 'test'
                }

M.std_modes = { 'single', 'proj' }

return M
