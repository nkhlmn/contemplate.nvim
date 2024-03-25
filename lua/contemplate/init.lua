local utils = require('contemplate.utils')

---@class (exact) ContemplateOpts
---@field temp_folder string
---@field save_file boolean
---@field templates_folder string
---@field data_folder string
---@field include_default_entries boolean
---@field entries? ContemplateEntry[]

---@class ContemplateEntry
---@field arg string
---@field display_name string
---@field name? string
---@field folder? string
---@field save_file? boolean

---@class Contemplate
---@field entries ContemplateEntry[]
---@field default_entries ContemplateEntry[]
---@field opts ContemplateOpts
---@field get_config function
---@field get_entries function
---@field create_contemplate_win function
---@field setup function
local M = {
  entries = {
    { arg = 'js',   display_name = 'Javascript' },
    { arg = 'lua',  display_name = 'Lua' },
    { arg = 'sql',  display_name = 'SQL' },
    { arg = 'json', display_name = 'JSON' },
    { arg = 'html', display_name = 'HTML' },
    { arg = 'md',   display_name = 'Markdown' },
    { arg = 'sh',   display_name = 'Shell' },
  },
  opts = {
    temp_folder = '~/',
    save_file = true,
    templates_folder = vim.fn.stdpath('config') .. '/templates/',
    data_folder = vim.fn.stdpath('data') .. '/contemplate/',
    include_default_entries = true,
  },
}

---@return ContemplateOpts
function M.get_config()
  local user_config = vim.g.contemplate_config or {}
  return vim.tbl_deep_extend('force', M.opts, user_config)
end

---@return table
function M.get_entries()
  return M.entries
end

---Open a new scratchpad buffer
---@param entry ContemplateEntry
---@param opts table
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

---@param opts ContemplateOpts
function M.setup(opts)
  if opts ~= nil and type(opts) == 'table' then
    M.opts = vim.tbl_deep_extend('force', M.opts, opts)
  end

  local user_entries = opts.entries or {}
  if opts.include_default_entries ~= false then
    M.entries = vim.tbl_extend('force', M.entries, user_entries)
  else
    M.entries = user_entries
  end
end

return M
