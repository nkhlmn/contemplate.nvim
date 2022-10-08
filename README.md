# contemplate.nvim

## Installation

```lua 
use {
      'nkhlmn/contemplate.nvim',
      config = function()
        require('contemplate').setup({
          entries = {
            { 'scratch.js', 'Scratch' },
            { 'javascript', 'Javascript' },
            { 'typescript', 'Typescript' },
            { 'lua', 'Lua' },
            { 'markdown', 'Markdown' },
            { 'python', 'Python' },
            { 'json', 'JSON' },
            { 'yaml', 'YAML' },
          },
        })
      end,
    },

```
