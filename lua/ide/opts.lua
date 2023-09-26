-- user-supplied option, hence most fields are optional
---@alias opts user-actions-set

-- M.example_opts =
-- { single = { java = { build = 'javac %s'
--                     , interpret = 'java %s'
--                     }
--            }
-- , project = { haskell = { build = 'cabal build' }
--             }
-- }

local L = require 'ide.core.lib'

local M = {}

-- Currently opts is just user-actions-set
-- so no transformations done
---@type fun(_: opts): user-actions-set
M.get_user_actions_set = L.id

return M
