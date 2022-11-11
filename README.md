# contemplate.nvim

## :exclamation::exclamation::exclamation: WIP :exclamation::exclamation::exclamation:

Quickly select and open a new buffer based on a file template or a filetype

## Installation

Example installation and configuration using `packer`:

```lua
use { 'nkhlmn/contemplate.nvim' }
```

### (optional but recommended) Telescope support

This plugin is intended to be used with telescope. A limited amount of functionality is possible without it though (see usage).

Ensure that you have loaded the extension in your telescope config:

```lua
require('telescope').load_extension('contemplate')
```

## Configuration

```lua
vim.g.contemplate_config = {
  entries = {
    { arg = 'scratch.js', display_name = 'JS scratchpad' },
    { arg = 'lua', display_name = 'Neovim Lua', name = 'nvim_lua' },
    { arg = 'lua', display_name = 'Neovim Foo', name = 'foo_nvim_lua', folder = '~/development/sandbox/foo/' },
  },
  include_defaults = false,
  temp_folder = '~/development/sandbox/'
}
```

# Usage

Call `:Contemplate` without any args to open a telescope picker (if installed).

You can also pass an argument, which should either be the filetype of the new buffer or the name of a template file located in `${stdpath('config')}/templates/`. E.g. `:Contemplate scratchpad.js`. Completion for these items will provided based on the entries configured, but it will only look at the `arg` and other config options will be ignored.

If you have telescope installed you can also open the picker by calling `:Telescope contemplate`

## TODO

- option to specify per-entry templates folder
- support passing a function to `filename` config object
- option to override timestamp?
- improve non-telescope support?
