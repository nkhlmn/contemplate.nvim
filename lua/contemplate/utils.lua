local M = {}

function M.split_lines(contents)
	local lines = {}
	for line in string.gmatch(contents, "(.-)\n") do
		table.insert(lines, line)
	end
	return lines
end

function M.get_file_contents(file_path)
	if file_path == nil then
		return ""
	end

	local file = io.open(file_path)
	if file ~= nil then
		return file:read("a")
	else
		return ""
	end
end

function M.get_file_lines(file_path)
	local file_contents = M.get_file_contents(file_path)
	return M.split_lines(file_contents)
end

function M.is_filename(arg)
	return arg:match("%.%a+$") ~= nil
end

function M.get_timestamp_prefix()
	local current_date = os.date("*t")
	local output = string.format(
		"%02d-%02d-%02d_%02d%02d%02d",
		current_date.month,
		current_date.day,
		string.sub(tostring(current_date.year), 3, 4),
		current_date.hour,
		current_date.min,
		current_date.sec
	)
	return output
end

function M.get_temp_filename(opts)
	local timestamp_prefix = M.get_timestamp_prefix()
  if opts.name and opts.file_extension then
		return string.format("%s-%s.%s", timestamp_prefix, opts.name, opts.file_extension)
  elseif opts.filename ~= nil then
		return string.format("%s-%s", timestamp_prefix, opts.filename)
  elseif opts.filename and opts.name ~= nil then
    local file_extension = string.match(opts.filename, "%w+.(%w+)$")
		return string.format("%s-%s.%s", timestamp_prefix, opts.name, file_extension)
	elseif opts.file_extension then
		return string.format("%s.%s", timestamp_prefix, opts.file_extension)
	else
		error("Must provide either a filename or file_extension")
	end
end

return M
