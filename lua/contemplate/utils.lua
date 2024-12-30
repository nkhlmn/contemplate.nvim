local M = {}

---@param contents string
---@return string[]
function M.split_lines(contents)
  local lines = {}
  for line in string.gmatch(contents, '(.-)\n') do
    table.insert(lines, line)
  end
  return lines
end

---@param filename string
---@return string
function M.get_file_contents(filename)
  if filename == nil then
    return ''
  end

  local file = io.open(filename)
  if file ~= nil then
    return file:read('a')
  else
    return ''
  end
end

---@param filename string
---@return string[]
function M.get_file_lines(filename)
  local contents = M.get_file_contents(filename)
  return M.split_lines(contents)
end

---@param arg string
---@return boolean
function M.is_filename(arg)
  if arg ~= nil then
    local match = arg:match('%.%w+$')
    return match ~= nil
  else
    return false
  end
end

---@return string
function M.get_timestamp_prefix()
  local current_date = os.date('*t')
  local output = string.format(
    '%02d%02d%02dT%02d%02d%02d',
    current_date.year,
    current_date.month,
    current_date.day,
    current_date.hour,
    current_date.min,
    current_date.sec
  )
  return output
end

---@param entry ContemplateEntry
---@return string
function M.get_temp_filename(entry)
  local arg = entry.arg or entry
  local is_filename = M.is_filename(arg)
  local timestamp = M.get_timestamp_prefix()

  if not is_filename and entry.name ~= nil then
    return string.format('%s-%s.%s', entry.name, timestamp, arg)
  elseif not is_filename then
    return string.format('%s.%s', timestamp, arg)
  elseif is_filename and entry.name ~= nil then
    local file_extension = string.match(arg, '%w+.(%w+)$')
    return string.format('%s-%s.%s', entry.name, timestamp, file_extension)
  elseif is_filename then
    local extension = string.match(arg, '%w+.(%w+)$')
    local name = string.match(arg, '(%w+).%w+$')
    return string.format('%s-%s.%s', name, timestamp, extension)
  else
    error('Could not generate a filename!')
  end
end

---@param opts table
function M.open_new_window(opts)
  if opts.split == 'h' then
    vim.cmd.new()
  elseif opts.split == 'v' then
    vim.cmd.vnew()
  elseif opts.new_tab then
    vim.cmd.tabnew()
  else
    local buf = vim.api.nvim_create_buf(true, true)
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, buf)
  end
end

---@param opts ContemplateOpts
---@param file_path string
function M.save_file(opts, file_path)
    local is_filename = M.is_filename(file_path)
    local buf = vim.api.nvim_get_current_buf()
    local filetype = vim.api.nvim_get_option_value('filetype', { buf = buf })
    vim.cmd.write()
    vim.fn.system('mkdir ' .. opts.data_folder)
    local hist_file_path = opts.data_folder .. 'contemplate_history.txt'
    local normalized_file_path = vim.uv.fs_realpath(vim.fn.expand(file_path))
    local cmd = 'echo "' .. normalized_file_path .. '" >> ' .. hist_file_path
    vim.fn.system(cmd)

    if filetype == 'sh' and not is_filename then
      -- Make file executable if it's a shell script
      vim.cmd('!chmod +x ' .. file_path)
    end
end

---@param opts ContemplateOpts
---@param arg string
function M.init_buffer(opts, arg)
  local is_filename = M.is_filename(arg)
  local buf = vim.api.nvim_get_current_buf()
  local filetype = vim.api.nvim_get_option_value('filetype', { buf = buf })

  -- Template file was provided; insert it's contents into the new buf
  if is_filename then
    local template_path = opts.templates_folder .. arg
    local lines = M.get_file_lines(template_path)
    vim.api.nvim_buf_set_lines(buf, 0, 0, false, lines)
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
  else
    -- Template was not provided; do special handling for certain filetypes
    if filetype == 'sh' then
      -- Insert shebang for shell scripts
      vim.api.nvim_buf_set_lines(buf, 0, 0, false, { '#!/bin/sh' })
    end
  end
end

return M
