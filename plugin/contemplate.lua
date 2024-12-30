local contemplate = require('contemplate')

-- Create `Contemplate` command
local function contemplate_cmd_handler(args)
  local selected_entry = args.fargs[1]
  if selected_entry ~= nil then
    contemplate.create_contemplate_win(selected_entry, {})
  else
    contemplate.open_template_picker()
  end
end

local function get_completion_items()
  local completion_items = {}
  local entries = contemplate.get_entries(true)
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

local function open_history(_)
  contemplate.open_history_picker()
end

local function clear_history(_)
  local history_file_path  = vim.fn.stdpath('data') .. '/contemplate/contemplate_history.txt'
  vim.fn.delete(history_file_path)
end

vim.api.nvim_create_user_command('Contemplate', contemplate_cmd_handler, contemplate_cmd_opts)
vim.api.nvim_create_user_command('ContemplateHistory', open_history, {})
vim.api.nvim_create_user_command('ContemplateClearHistory', clear_history, {})
