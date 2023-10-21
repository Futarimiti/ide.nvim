# ide.nvim

Basic framework for basic IDE support

## Functionalities

- [x] Can manually specify which programmes to be used for building, interpreting, debugging, REPL, testing, etc.
- [x] Provides sensible presets for some languages
- [x] Exports a module `ide.user` with functionalities as functions for easier command/keymaps setup
- [x] Provides command `IDE`
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
corresponding to single-file mode and project mode, obviously.
Then for each mode, we have a table of filetypes,
of which we will specify the *actions*,
which are tables of action names (interpret, build, repl...) and action commands.
Action commands are usually in string, where an `'%s'` may be used to represent the file name.
For some complicated actions, a function may be used (see below).

Commons actions are collected as standard actions;
you can see standard modes and actions
and their interpretations [here](lua/ide/const.lua).
If you feel like these are not enough,
use option `other_modes` and `other_actions` to add more!

Some sensible presets are provided for some languages/implementations,
available [here](lua/presets/). You can use them like this:

```lua
local p = require 'ide.presets'

{ single = { java = p.java_preview(21)  -- some presets have callable metatables
           , python = { interpret = p.python(3.12).interpret
                      , repl = p.ptpython.repl
                      , repl_loaded = p.ptpython.repl_loaded
                      }  -- you can mix up different presets!
           }
, proj = { java = p.maven
         , haskell = p.cabal
         }
}
```

## Usage & Customisation

`ide.nvim` provides a command `IDE` to perform actions.
The command takes two arguments: `mode` and `action`,
both supported by argument completion,
to perform the action on the current buffer.
For example, with the configuration above,
when we execute `:IDE interpret single` in a java file,
we will see a terminal window pop up and execute `java <filename>`.
The command can be disabled or even renamed in the configuration.

Alternatively, you may use `ide.user` module to perform actions
in a `u[<mode>][<action>]` manner,
which is equivalent to `IDE <mode> <action>`.
This can be helpful in setting up keymaps:

```lua
local u = require 'ide.user'

vim.keymap.set('n', '<leader>b', u.single.build)
vim.keymap.set('n', '<leader>B', u.proj.build)
vim.keymap.set('n', '<leader>i', u.single.repl)
...
```

I do not like reaching my hands too far,
so I do not plan to include keymap options
as users can easily do this themselves as above.

## Advanced

If things are so complex, say I'd like to load a file into racket REPL
with one click, and the only way to do so is to run
`,enter <filename>` within the REPL, how can I do that?
A string command is apparently not enough; a function can be used instead.

When used as a function, one of the following scheme should be adopted:

* `fun(buf): cmd`
* `fun(buf, win)`

In the first scheme, `buf` is the buffer number of the current buffer,
which should be helpful for providing more information.
The function *must* return a string command to be executed,
where `'%s'` may still be used to represent the file name.

In the second scheme, `buf` is the buffer number of the current buffer
and `win` is the window number of the new IDE terminal window,
on which you may run commands like `vim.api.nvim_win_set_buf(win, buf)`
or `feedkeys`, whichever you feel needed to achieve your goal.
The function *must not* return anything, otherwise the plugin will be confused.

So to solve the problem earlier, we can write:
```lua
local repl_loaded = function (buf, win)
    local pt = expand(this, '%:p:t')
    local phS = expand(this, '%:p:h:S')
    vim.api.nvim_win_call(win, function ()
      vim.fn.termopen('cd '.. phS .. '; racket -i')
      vim.cmd.startinsert()
      vim.api.nvim_input(',enter "' .. pt .. '"<CR>')
    end)
end

{ single = { racket = { repl_loaded = repl_loaded } } }
```

## Contribution

This plugin is its very early stage
so do expect unstable changes and breaking changes.
Any suggestions or issues, just open an issue or a PR
and we will get to work ASAP.
