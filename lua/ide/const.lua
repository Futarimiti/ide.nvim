local M = {}

M.std_actions = { 'build'  -- build current file/project
                , 'interpret'  -- interpret current file/project?
                , 'run'  -- build & run current file/project
                , 'exec'  -- without another build, run current file/project
                , 'debug'  -- debug on the current file/project
                , 'repl'  -- open a REPL for the current file/project
                , 'repl_loaded'  -- open a REPL loading current file/project
                , 'test'  -- run tests on current file/project
                , 'typecheck'  -- typecheck current file/project without running
                }

M.std_modes = { 'single', 'proj' }

return M
