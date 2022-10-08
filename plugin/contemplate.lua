local contemplate = require('contemplate')

vim.api.nvim_create_user_command('Contemplate', function() contemplate.open_contemplate_picker() end, { force = true })
