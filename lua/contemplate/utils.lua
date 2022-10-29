local M = {}

function M.split_lines(contents)
  local lines = {}
  for line in string.gmatch(contents, '(.-)\n') do
    table.insert(lines, line)
  end
  return lines
end

function M.get_file_contents(file_path)
  if file_path == nil then
    return ''
  end

  local file = io.open(file_path)
  if file ~= nil then
    return file:read('a')
  else
    return ''
  end
end

function M.get_file_lines(file_path)
  local file_contents = M.get_file_contents(file_path)
  return M.split_lines(file_contents)
end

function M.is_filename(arg)
  if arg ~= nil then
    local match = arg:match('%.%a+$')
    return match ~= nil
  else
    return false
  end
end

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

return M
