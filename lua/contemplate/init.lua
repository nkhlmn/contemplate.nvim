local utils = require('contemplate.utils')
local M = {}

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
	if utils.is_filename(arg) then
		temp_filename_opts.filename = arg
	else
		temp_filename_opts.file_extension = arg
	end

	local temp_filename = utils.get_temp_filename(temp_filename_opts)
  local file_path = M.temp_folder .. temp_filename
  vim.cmd.edit(file_path)

	if utils.is_filename(arg) then
    local buf = vim.api.nvim_get_current_buf()
		local template_path = M.templates_folder .. arg
		local lines = utils.get_file_lines(template_path)
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
