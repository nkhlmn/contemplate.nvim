local contemplate = require('contemplate')

local function entry_maker(entry)
  if type(entry) == 'string' then
    return { value = entry, display = entry, ordinal = entry }
  elseif type(entry) == 'table' then
    local display = entry.display_name or entry.arg
    return { value = entry, display = display, ordinal = display }
  end
end

local function attach_mappings(prompt_bufnr, _)
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')

  actions.select_default:replace(function()
    actions.close(prompt_bufnr)
    local entry = action_state.get_selected_entry()
    contemplate.create_contemplate_win(entry.value, {})
  end)

  actions.select_vertical:replace(function()
    actions.close(prompt_bufnr)
    local entry = action_state.get_selected_entry()
    contemplate.create_contemplate_win(entry.value, { split = 'v' })
  end)

  actions.select_horizontal:replace(function()
    actions.close(prompt_bufnr)
    local entry = action_state.get_selected_entry()
    contemplate.create_contemplate_win(entry.value, { split = 'h' })
  end)

  actions.select_tab:replace(function()
    actions.close(prompt_bufnr)
    local entry = action_state.get_selected_entry()
    contemplate.create_contemplate_win(entry.value, { new_tab = true })
  end)

  return true
end

local function get_telescope_picker(results, opts)
  local pickers = require('telescope.pickers')
  local conf = require('telescope.config').values
  local finders = require('telescope.finders')
  local dropdown = require('telescope.themes').get_dropdown({})
  opts = vim.tbl_deep_extend('force', dropdown, opts or {})

  if results == nil then
    results = {}
  end

  local config = contemplate.get_config()
  local contemplate_entries = contemplate.get_entries(config.include_defaults or true)

  if contemplate_entries ~= nil and type(contemplate_entries) == 'table' then
    results = vim.list_extend(results, contemplate_entries)
  end

  local finder = finders.new_table({ results = results, entry_maker = entry_maker })
  local picker = pickers.new(opts, {
    prompt_title = 'Contemplate',
    finder = finder,
    sorter = conf.generic_sorter(opts),
    attach_mappings = attach_mappings,
  })
  return picker
end

--- Open a telescope picker with a set of results provided
-- @param results: the options the picker will display. Should be an array of strings that are either a filetype or the name of a template
-- @param opts: options for the telescope picker
-- Example: require('config.utils').open_contemplate_picker({ 'scratch.js', 'javascript', 'lua','markdown' })
local function open_contemplate_picker(results, opts)
  local picker = get_telescope_picker(results, opts)
  picker:find()
end

local function open_history_picker(results, opts)
  local history_file_path = vim.fn.stdpath('data') .. '/contemplate/contemplate_history.txt'

  if vim.fn.filereadable(history_file_path) == 0 then
    vim.fn.system('touch ' .. history_file_path)
  end

  results = vim.fn.readfile(history_file_path)

  local pickers = require('telescope.pickers')
  local conf = require('telescope.config').values
  local finders = require('telescope.finders')

  local finder = finders.new_table({
    results = results,
    entry_maker = function(entry)
      return { value = entry, display = entry, ordinal = entry }
    end,
  })

  local picker = pickers.new(opts, {
    prompt_title = 'Contemplate History',
    finder = finder,
    sorter = conf.generic_sorter(opts),
  })

  picker:find()
end

return require('telescope').register_extension({
  exports = {
    contemplate = open_contemplate_picker,
    contemplate_history = open_history_picker,
  },
})
