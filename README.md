# contemplate.nvim

Quickly select and open a new buffer based on a file template or a filetype

## Installation

Example installation and configuration using `packer`:

```lua
use { 'nkhlmn/contemplate.nvim' }
```

### Telescope support (optional, but recommended)

This plugin is intended to be used with telescope.
A limited amount of functionality is possible without it though (see usage).

Ensure that you have loaded the extension in your telescope config:

```lua
require('telescope').load_extension('contemplate')
```

## Configuration

Define a `vim.g.contemplate_config` variable with your configuration. For example:

```lua
-- Example user config:
vim.g.contemplate_config = {
  entries = {
    { arg = 'scratch.js', display_name = 'JS scratchpad' },
    { arg = 'lua', display_name = 'Neovim Lua', name = 'nvim_lua' },
    { arg = 'lua', display_name = 'Neovim Foo', name = 'foo_nvim_lua', folder = '~/development/sandbox/foo/' },
  },
  include_defaults = false,
  temp_folder = '~/development/sandbox/'
}

-- Default config:
default_config = {
  entries = {},
  temp_folder = '~/', -- Location to save file
  save_file = true, -- Auto save file after creation
  templates_folder = vim.fn.stdpath('config') .. '/templates/', -- Location for template files
  include_defaults = true, -- Include default entries in telescope pickers
}

-- Default entries
default_entries = {
  { arg = 'js', display_name = 'Javascript' },
  { arg = 'lua', display_name = 'Lua' },
  { arg = 'python', display_name = 'Python' },
  { arg = 'go', display_name = 'Go' },
  { arg = 'sql', display_name = 'SQL' },
  { arg = 'json', display_name = 'JSON' },
  { arg = 'sh', display_name = 'Shell' },
  { arg = 'md', display_name = 'Markdown' },
}
```

## Usage

### With telescope.nvim

Call `:Contemplate` without any args to open a telescope picker (if installed)
or by calling `:Telescope contemplate`.

### Without telescope.nvim

An argument is required when calling `:Contemplate` without telescope.nvim
installed. The argument should either be the filetype of the new buffer or the
name of a template file. E.g. `:Contemplate scratchpad.js`. Completion for
these items will provided based on the entries configured, but it will only look
at the `arg` and other config options will be ignored.

## TODO

- support passing a function to `filename` config object
- option to override timestamp?
- improve non-telescope support?
