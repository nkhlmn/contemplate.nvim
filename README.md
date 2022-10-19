# contemplate.nvim

## :exclamation::exclamation::exclamation: WIP :exclamation::exclamation::exclamation:

Quickly select and open a new buffer based on a file template or a filetype

## Installation

```lua
use {
      'nkhlmn/contemplate.nvim',
      config = function()
        require('contemplate').setup({
          -- specify location where files will be saved
          temp_folder = '~/', 

          -- save file automatically
          save_file = true,

          -- define entries 
          entries = {
            { arg = 'scratch.js', display_name = 'JS scratchpad' } -- `arg` is required; it can be a filename in the templates folder, or a file extension
            { arg = 'lua', folder = '~/development/sandbox/lua/'}, -- `folder` overrides the global temp_folder
          },
        })
      end,
    }
```

### (optional) Telescope support

Ensure that you have loaded the extension in your telescope config:

```lua
require('telescope').load_extension('contemplate')
```

# Usage

Call `:Contemplate` without any args to open a telescope picker (if installed).

You can also pass an argument, which should either be the filetype of the new buffer or the name of a template file located in `${stdpath('config')}/templates/`. E.g. `:Contemplate scratchpad.js`.

If you have telescope installed you can also open the picker by calling `:Telescope contemplate`

## TODO

- support passing a function to `filename` config object
  - option to override timestamp?
- support specifying templates folder location
- support per-entry `save_file` option
- auto load template files in templates directory?
- option to clear default entries?
  - alternatively, don't provide defaults at all (use a list of vim filetypes if no entries are defined)?
