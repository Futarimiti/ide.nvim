local expand = function (buf_id, pat) return vim.api.nvim_buf_call(buf_id, function () return vim.fn.expand(pat) end) end
local classname = function (buf_id) return expand(buf_id, '%:t:r:S') end

local M = {}

M.java = { build = 'javac %s'
         , interpret = 'java %s'
         , debug = function (id) return 'jdb ' .. classname(id) end
         , repl = 'jshell'
         , repl_loaded = 'jshell --startup %s'
         }

M.maven = { build = 'mvn compile'
          , run = 'mvn exec:java'
          , test = 'mvn test'
          }

---@param version (integer | string)?
local java_preview_version = function (version)
  local ver = version and tostring(version)
  return
  { build = ver and 'javac --enable-preview --release ' .. ver .. ' %s' or nil
  , interpret = ver and 'java --enable-preview --source ' .. ver .. ' %s' or nil
  , repl = 'jshell --enable-preview'
  , repl_loaded = 'jshell --enable-preview --startup %s'
  }
end

-- since javac and java commands must be provided with the same version
-- when using --enable-preview, they will be set to nil if you do not
-- provide a version; only repl, repl_loaded and interpret will be set
-- since jshell does not need a version.
local java_preview = java_preview_version(nil)
setmetatable(java_preview, { __call = function (_, version) return java_preview_version(version) end })

M.java_preview = java_preview

return M
