# contemplate.nvim

Quickly select and open a new buffer based on a file template or a filetype

## Installation

```lua
use {
      'nkhlmn/contemplate.nvim',
      config = function()
        require('contemplate').setup({
          -- add custom entries
          entries = {
            'foo.lua',                         -- can be the name of a file template in ${stdpath('config')}/templates/
            'toml',                            -- or can be the name of the filetype for an empty buffer
            { 'scratch.js', 'JS scratchpad' }, -- you can also provide a list; the second item will be the display name used in telescope
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

- create temp file
- support specifying temp file location (per template?)
- auto load template files in templates directory
- support specifying templates folder location
