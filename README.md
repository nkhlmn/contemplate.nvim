# contemplate.nvim

## :exclamation::exclamation::exclamation: WIP :exclamation::exclamation::exclamation:

Quickly select and open a new buffer based on a file template or a filetype

## Installation

Example installation and configuration using `packer`:
```lua
use {
  'nkhlmn/contemplate.nvim',
    config = function()
      -- call the `setup` function; 
  require('contemplate').setup({
      -- specify location where files will be saved (defaults to `~/`)
      temp_folder = '~/development/sandbox/', 

      -- save file automatically to the `temp_folder` when it is created (defaults to true)
      save_file = true,

      -- don't use an initial set of entries (defaults to true)
      keep_default_entries = false,

      -- define entries 
      entries = {
      { arg = 'scratch.js', display_name = 'JS scratchpad' } -- `arg` is required; it can be a filename in the templates folder, or a file extension
      { arg = 'lua', folder = '~/development/sandbox/lua/'}, -- `folder` overrides the global temp_folder
      },
      })
  end,
}
```

### (optional but recommended) Telescope support

This plugin is intended to be used with telescope. A limited amount of functionality is possible without it though (see usage).

Ensure that you have loaded the extension in your telescope config:

```lua
require('telescope').load_extension('contemplate')
```

# Usage

Call `:Contemplate` without any args to open a telescope picker (if installed).

You can also pass an argument, which should either be the filetype of the new buffer or the name of a template file located in `${stdpath('config')}/templates/`. E.g. `:Contemplate scratchpad.js`. Completion for these items will provided based on the entries configured, but it will only look at the `arg` and other config options will be ignored.

If you have telescope installed you can also open the picker by calling `:Telescope contemplate`

## TODO

- option to specify templates folder location; including per-entry
- support passing a function to `filename` config object
- option to override timestamp?
- option to auto load template files in templates directory?
  - alternatively, don't provide defaults at all (use a list of vim filetypes if no entries are defined)?
- improve non-telescope support?
  - allow for passing multiple arguments and handle completion based on config entries
