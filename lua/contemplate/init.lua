local M = {}

local function split_lines(contents)
	local lines = {}
	for line in string.gmatch(contents, "(.-)\n") do
		table.insert(lines, line)
	end
	return lines
end

local function get_file_contents(file_path)
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

local function get_file_lines(file_path)
	local file_contents = get_file_contents(file_path)
	return split_lines(file_contents)
end

local function is_filename(arg)
	return arg:match("%.%a+$")
end

local function get_timestamp_prefix()
	local current_date = os.date("*t")
	local output = string.format(
		"%02d%02d%s_%02d%02d%02d",
		current_date.month,
		current_date.day,
		string.sub(tostring(current_date.year), 3, 4),
		current_date.hour,
		current_date.min,
		current_date.sec
	)
	return output
end

local function get_temp_filename(opts)
	local timestamp_prefix = get_timestamp_prefix()
	if opts.filename ~= nil then
		return string.format("%s_%s", timestamp_prefix, opts.filename)
	elseif opts.file_extension then
		return string.format("%s.%s", timestamp_prefix, opts.file_extension)
	else
		error("Must provide either a filename or file_extension")
	end
end

--- Open a new scratchpad buffer
-- @param arg: string specifying filetype or path to template
function M.create_contemplate_win(arg, opts)
	if opts.split == "h" then
		vim.cmd.new()
	elseif opts.split == "v" then
		vim.cmd.vnew()
	elseif opts.new_tab then
		vim.cmd.tabnew()
	else
		local buf = vim.api.nvim_create_buf(true, true)
		local win = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_buf(win, buf)
	end

	local temp_filename_opts = {}
	if is_filename(arg) then
		temp_filename_opts.filename = arg
	else
		temp_filename_opts.file_extension = arg
	end

	local temp_filename = get_temp_filename(temp_filename_opts)
  local file_path = M.temp_folder .. temp_filename
  vim.cmd.edit(file_path)

	if is_filename(arg) then
    local buf = vim.api.nvim_get_current_buf()
		local template_path = M.templates_folder .. arg
		local lines = get_file_lines(template_path)
		vim.api.nvim_buf_set_lines(buf, 0, 0, false, lines)
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
  end

  if M.save_file then
    vim.cmd.write()
  end
end

M.entries = {}

function M.add_to_entries(entries)
	vim.list_extend(M.entries, entries)
end

function M.setup(opts)
	if opts.entries ~= nil and type(opts.entries) == "table" then
		M.add_to_entries(opts.entries)
	end
end

return M
