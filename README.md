# ide.nvim

Basic framework for basic IDE support

## Functionalities

- [x] Manually, or use presets, specify which programmes to be used for building, interpreting, debugging, REPL, testing, etc.
- [x] Provides sensible presets for some languages
- [x] Exports utility module for easier command/keymaps setup
- [x] Provides command
    - [x] Argument completion

## Installation

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
return
{ 'Futarimiti/ide.nvim'
, branch = 'v2'
}
```

I am not planning on writing vimdoc for this plugin,
as readme should suffice.
If you prefer `:h` inside nvim, you should install using lazy
which generates vimdoc from this readme.

## Configuration

Configuration for this plugin includes ordinary options
and a more complicated, core `setups` option.
See [here](lua/ide/config/defaults.lua) for the full default configuration
and some comments on the options.

### `setups`

`setups` option describes what to do for each action on each mode for each filetype.
Confused? Here's an example:

```lua
{ single = { java = { interpret = 'java %s'
                    , build = 'javac %s'
                    , repl = 'jshell'
                    , repl_loaded = 'jshell --startup %s'
                    }
           , python = { interpret = 'python %s'
                      , repl = 'python'
                      }
           }
, proj = { java = { build = 'maven compile'
                  , test = 'maven test'
                  }
         , haskell = { build = 'cabal build'
                     , repl = 'cabal repl'
                     }
         }
}
```

Here `single` and `proj` are *modes*,
corresponding to the fact that a file may be run in either single-file mode or project mode.
Then for each mode, a table of filetypes to *actions* is specified,
which are in turn tables of action names (interpret, build, repl...) and action commands.
Action commands are usually in string, with `'%s'` used to substitute the file name, if needed.
For more complicated actions, a function may be used (see below).

I've collected some common actions and modes as the standards,
see their interpretations [here](lua/ide/const.lua).
Use option `other_modes` and `other_actions` to add more
if you find something missing!

Some sensible presets are provided for some languages/implementations,
available [here](lua/ide/presets/). They can be used like this:

```lua
local p = require 'ide.presets'

require('ide').setup
  { setups = { single = { java = p.java_preview(21)  -- some presets provide callable metatables
                        , python = { interpret = p.python(3.12).interpret
                                   , repl = p.ptpython.repl
                                   , repl_loaded = p.ptpython.repl_loaded
                                   }  -- you can mix up different presets!
                        }
             , proj = { java = p.maven
                      , haskell = p.cabal
                      }
             }
  }
```

## Usage & Customisation

`ide.nvim` provides a command (default `IDE`)
to perform actions such as running code, building, testing, etc
on the current buffer.
This could be disabled or renamed by configuration.

The command goes in the form of `:IDE <mode> <action>`
with both args coming with tab completion.
Executing `:IDE single interpret` for instance will interpret on the current file.
If we are on java, a terminal window executing `java <filename>` will pop up.

Equivalently, `ide.user` module may be used to set up, say, keymaps:

```lua
local u = require 'ide.user'

vim.keymap.set('n', '<leader>b', u.single.build)
vim.keymap.set('n', '<leader>B', u.proj.build)
vim.keymap.set('n', '<leader>i', u.single.repl)
...
```

I hate reaching my hands too far
so there's no plan to include keymap options
as users can easily do this themselves as above.

## Advanced

If things get so complex, say I'd like to load a file into racket REPL
with one click, and the only way to do so is to run
`,enter <filename>` *within* the REPL, how can I do that?
A string command is apparently not enough; a function can be used instead.

When used as a function, one of the following scheme should be adopted:

* `fun(buf): cmd` where
    `buf` is the buffer number of the current buffer
    and `cmd` is a string command to be executed
    (where `'%s'` may still be used to represent the file name)
* `fun(buf, win)` where
    `buf` is the buffer number of the current buffer
    and `win` is the window number of the new IDE terminal window,
    on which you may run commands like `nvim_win_set_buf`
    or `feedkeys`, whichever necessary to achieve your goal.
    The plugin will get confused if the function returns anything.

Therefore we can do something like this:

```lua
local repl_loaded = function (buf, win)
  local pt = vim.fn.expand(this, '%:p:t')
  local phS = vim.fn.expand(this, '%:p:h:S')
  vim.api.nvim_win_call(win, function ()
    vim.fn.termopen('cd '.. phS .. '; racket -i')
    vim.cmd.startinsert()
    vim.api.nvim_input(',enter "' .. pt .. '"<CR>')
  end)
end

require('ide').setup { setups = { single = { racket = { repl_loaded = repl_loaded } } } }
```

## Contribution

I wrote this like just yesterday
so do expect it to break tomorrow.
There may as well be breaking changes
without preannouncements.

Any suggestions or issues, just open an issue or a PR
and we will get to work ASAP.
