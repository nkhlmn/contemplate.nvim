# contemplate.nvim

Quickly select and open a new buffer based on a file template or a filetype.

## Installation

Example installation and configuration using `packer`:

Install the plugin with your preferred neovim package manager.

### Telescope support (optional, but recommended)

This plugin is intended to be used with telescope.
A limited amount of functionality is possible without it though (see usage).

Ensure that you have loaded the extension in your telescope config:

```lua
require('telescope').load_extension('contemplate')
```

## Configuration

Call the `setup` function only if you need to set custom options. E.g.

```lua
-- Opts shown below are the defaults that will be set if `setup()` is not called:
local opts = {
  -- Defines the options that will show up. See more about how this works in the section below
  entries = {
    { arg = 'js', display_name = 'Javascript' },
    { arg = 'lua', display_name = 'Lua' },
    { arg = 'python', display_name = 'Python' },
    { arg = 'go', display_name = 'Go' },
    { arg = 'sql', display_name = 'SQL' },
    { arg = 'json', display_name = 'JSON' },
    { arg = 'sh', display_name = 'Shell' },
    { arg = 'md', display_name = 'Markdown' },
  },

  -- Location to save file
  temp_folder = '~/',

  -- Auto save file after creation
  save_file = true,

  -- Location to look for template files
  templates_folder = vim.fn.stdpath('config') .. '/templates/',

  -- Include default entries in telescope pickers/menu completion
  --    `true` will merge the default entries with your own
  --    `false` will override the defaults with your own
  include_default_entries = true,
}

require('comtemplate').setup(opts)

```

### Entry

TODO: This is how you determine what shows up in the telescope picker/menu completion and what it does.

## Usage

Telescope is recommended for this but some limited functionality is avaiable without it.

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
