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

	local buf = vim.api.nvim_get_current_buf()
	if is_filename(arg) then
		local filetype = vim.filetype.match({ filename = arg })
		local file_path = vim.fn.stdpath("config") .. "/templates/" .. arg
		local lines = get_file_lines(file_path)
		vim.api.nvim_buf_set_lines(buf, 0, 0, false, lines)
		vim.api.nvim_buf_set_option(buf, "ft", filetype)
	else
		vim.api.nvim_buf_set_option(buf, "ft", arg)
	end

	vim.api.nvim_win_set_cursor(0, { 1, 0 })
end

M.entries = {}

function M.setup(opts)
	if opts.entries ~= nil and type(opts.entries) == "table" then
		M.entries = opts.entries
	end
end

return M
