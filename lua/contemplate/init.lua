local utils = require('contemplate.utils')

local M = {
  entries = {},
  default_entries = {
    { arg = 'js', display_name = 'Javascript' },
    { arg = 'lua', display_name = 'Lua' },
    { arg = 'sql', display_name = 'SQL' },
    { arg = 'json', display_name = 'JSON' },
    { arg = 'html', display_name = 'HTML' },
    { arg = 'md', display_name = 'Markdown' },
    { arg = 'sh', display_name = 'Shell' },
  },
  default_config = {
    temp_folder = '~/',
    save_file = true,
    templates_folder = vim.fn.stdpath('config') .. '/templates/',
    data_folder = vim.fn.stdpath('data') .. '/contemplate/',
    include_defaults = true,
  },
}

function M.get_config()
  local user_config = vim.g.contemplate_config or {}
  return vim.tbl_deep_extend('force', M.default_config, user_config)
end

function M.get_entries()
  local config = M.get_config()
  local user_entries = config.entries or {}
  if config.include_defaults then
    vim.list_extend(user_entries, M.default_entries)
  end
  return user_entries
end

--- Open a new scratchpad buffer
function M.create_contemplate_win(entry, opts)
  local config = M.get_config()
  local arg = entry.arg or entry

  -- Open the window
  utils.open_new_window(opts)

  -- Get the filename
  local temp_filename = utils.get_temp_filename(entry)
  local file_folder = entry.folder or config.temp_folder
  local file_path = file_folder .. '/' .. temp_filename

  -- Open and init a new buffer
  vim.cmd.edit(file_path)
  utils.init_buffer(config, arg)

  -- Save the buffer
  local save_file = entry.save_file or config.save_file
  if save_file then
    utils.save_file(config, file_path)
  end
end

function M.set_entries(entries, keep_default_entries)
  if entries == nil then
    return
  end

  local new_entries = {}

  if type(entries) == 'table' then
    vim.list_extend(new_entries, entries)
  end

  if keep_default_entries then
    vim.list_extend(new_entries, M.default_entries)
  end

  M.entries = new_entries
end

function M.setup(opts)
  M.entries = M.default_entries

  for key, value in pairs(opts) do
    if key == 'entries' then
      M.set_entries(value, opts.keep_default_entries ~= false)
    else
      M[key] = value
    end
  end
end

return M
