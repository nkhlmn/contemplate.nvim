local contemplate = require('contemplate')
local has_telescope, telescope = pcall(require, 'telescope')

-- Create `Contemplate` command
local function contemplate_cmd_handler(args)
  local selected_entry = args.fargs[1]
  if selected_entry ~= nil then
    contemplate.create_contemplate_win(selected_entry, {})
  elseif has_telescope then
    telescope.extensions.contemplate.contemplate()
  else
    print('You must provide an argument.')
  end
end

local function get_completion_items()
  local completion_items = {}
  local entries = contemplate.entries
  for _, v in ipairs(entries) do
    if type(v) == 'string' then
      table.insert(completion_items, v)
    elseif type(v) == 'table' then
      if v.arg ~= nil and not vim.tbl_contains(completion_items, v.arg) then
        table.insert(completion_items, v.arg)
      end
    end
  end
  return completion_items
end

local contemplate_cmd_opts = {
  force = true,
  complete = get_completion_items,
  nargs = '?',
}

vim.api.nvim_create_user_command('Contemplate', contemplate_cmd_handler, contemplate_cmd_opts)
