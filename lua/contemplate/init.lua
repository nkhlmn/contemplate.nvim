local api = vim.api
local utils = require('contemplate.utils')

local M = {
  entries = {},
  default_entries = {
    { arg = 'js', display_name = 'Javascript' },
    { arg = 'lua', display_name = 'Lua' },
    { arg = 'python', display_name = 'Python' },
    { arg = 'go', display_name = 'Go' },
    { arg = 'sql', display_name = 'SQL' },
    { arg = 'json', display_name = 'JSON' },
    { arg = 'sh', display_name = 'Shell' },
    { arg = 'md', display_name = 'Markdown' },
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
  local is_filename = utils.is_filename(arg)

  -- Determine where to open the window
  if opts.split == 'h' then
    vim.cmd.new()
  elseif opts.split == 'v' then
    vim.cmd.vnew()
  elseif opts.new_tab then
    vim.cmd.tabnew()
  else
    local buf = api.nvim_create_buf(true, true)
    local win = api.nvim_get_current_win()
    api.nvim_win_set_buf(win, buf)
  end

  local temp_filename = utils.get_temp_filename(entry)

  -- Open the new file
  local file_folder = entry.folder or config.temp_folder
  local file_path = file_folder .. '/' .. temp_filename
  vim.cmd.edit(file_path)
  local buf = api.nvim_get_current_buf()
  local filetype = api.nvim_buf_get_option(buf, 'filetype')

  -- Template file was provided; insert it's contents into the new buf
  if is_filename then
    local template_path = config.templates_folder .. arg
    local lines = utils.get_file_lines(template_path)
    api.nvim_buf_set_lines(buf, 0, 0, false, lines)
    api.nvim_win_set_cursor(0, { 1, 0 })
  else
    -- Template was not provided; do special handling for certain filetypes
    if filetype == 'sh' then
      -- Insert shebang for shell scripts
      api.nvim_buf_set_lines(buf, 0, 0, false, { '#!/bin/sh' })
    end
  end

  -- Save the buffer
  local save_file = config.save_file
  if entry.save_file ~= nil then
    save_file = entry.save_file
  end

  if save_file then
    vim.cmd.write()
    vim.fn.system('mkdir ' .. config.data_folder)
    local hist_file_path = config.data_folder .. 'contemplate_history.txt'
    local normalized_file_path = vim.loop.fs_realpath(vim.fn.expand(file_path))
    local cmd = 'echo "' .. normalized_file_path .. '" >> ' .. hist_file_path
    vim.fn.system(cmd)

    if filetype == 'sh' and not is_filename then
      -- Make file executable if it's a shell script
      vim.cmd('!chmod +x ' .. file_path)
    end
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
