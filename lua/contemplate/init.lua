local utils = require('contemplate.utils')

local M = {
  entries = {},
  temp_folder = '~/',
  save_file = true,
  templates_folder = vim.fn.stdpath('config')..'/templates/',
}

--- Open a new scratchpad buffer
-- @param arg: string specifying filetype or path to template
function M.create_contemplate_win(entry, opts)
  local arg = entry.arg
  local display_name = entry.display_name
  local name = entry.name

  -- Determine where to open the window
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

  -- Generate the filename
	local filename_opts = {}
	if utils.is_filename(arg) then
		filename_opts.filename = arg
	else
		filename_opts.file_extension = arg
	end

  if display_name ~= nil then
    filename_opts.display_name = display_name
  end

  if name ~= nil then
    filename_opts.name = name
  end
	local temp_filename = utils.get_temp_filename(filename_opts)

  -- Open the new file
  local file_path = M.temp_folder .. temp_filename
  vim.cmd.edit(file_path)

  -- Insert the contents of the template, if provided, into the new file
	if utils.is_filename(arg) then
    local buf = vim.api.nvim_get_current_buf()
		local template_path = M.templates_folder .. arg
		local lines = utils.get_file_lines(template_path)
		vim.api.nvim_buf_set_lines(buf, 0, 0, false, lines)
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
  end

  -- Save the buffer
  if M.save_file then
    vim.cmd.write()
  end
end

function M.add_to_entries(entries)
	vim.list_extend(M.entries, entries)
end

function M.setup(opts)
	if opts.entries ~= nil and type(opts.entries) == "table" then
		M.add_to_entries(opts.entries)
	end

  if opts.temp_folder ~= nil then
    M.temp_folder = opts.temp_folder
  end

  if opts.save_file ~= nil then
    M.save_file = opts.save_file
  end
end

return M
