local utils = require("contemplate.utils")

local M = {
	entries = {},
	temp_folder = "~/",
	save_file = true,
	templates_folder = vim.fn.stdpath("config") .. "/templates/",
}

--- Open a new scratchpad buffer
-- @param arg: string specifying filetype or path to template
function M.create_contemplate_win(entry, opts)
	local arg = entry.arg
	local display_name = entry.display_name
	local name = entry.name
  local is_filename = utils.is_filename(arg)

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
	if is_filename then
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
  local file_folder = entry.folder or M.temp_folder
	local file_path = file_folder .. '/' .. temp_filename
	vim.cmd.edit(file_path)
  local buf = vim.api.nvim_get_current_buf()
  local filetype = vim.api.nvim_buf_get_option(buf, 'filetype')

	-- Template file was provided; insert it's contents into the new buf
	if is_filename then
		local template_path = M.templates_folder .. arg
		local lines = utils.get_file_lines(template_path)
		vim.api.nvim_buf_set_lines(buf, 0, 0, false, lines)
		vim.api.nvim_win_set_cursor(0, { 1, 0 })
  -- Template was not provided; do special handling for certain filetypes
  elseif filetype == 'sh' then
    -- Insert shebang for shell scripts
    vim.api.nvim_buf_set_lines(buf, 0, 0, false, { '#!/bin/sh' })
	end

	-- Save the buffer
	if M.save_file then
		vim.cmd.write()

    -- Make file executable if it's a shell script
    if filetype == 'sh' and not is_filename then
      vim.cmd('!chmod +x ' .. file_path)
    end
	end
end

function M.add_to_entries(entries)
  if type(entries) == "table" then
    M.entries = vim.list_extend(entries, M.entries)
  end
end

function M.setup(opts)
  for key, value in pairs(opts) do
    if key == 'entries' then
      M.add_to_entries(value)
    else
      M[key] = value
    end
  end
end

return M
