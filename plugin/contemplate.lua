local contemplate = require("contemplate")
local has_telescope, telescope = pcall(require, "telescope")

-- Initialize a default set of entries
local default_entries = {
  { "scratch.js", "JS scratchpad" },
  { "javascript", "Javascript" },
  { "typescript", "Typescript" },
  { "lua", "Lua" },
  { "markdown", "Markdown" },
  { "python", "Python" },
  { "json", "JSON" },
  { "yaml", "YAML" },
}

contemplate.add_to_entries(default_entries)


-- Create `Contemplate` command
local function contemplate_cmd_handler(args)
  local arg = args.fargs[1]
  if arg ~= nil then
    contemplate.create_contemplate_win(arg, { new_tab = true })
  elseif has_telescope then
    telescope.extensions.contemplate.contemplate()
  else
    print("You must provide an argument.")
  end
end

local function get_completion_items()
  local completion_items = {}
  local entries = contemplate.entries
  for _, v in ipairs(entries) do
    if type(v) == 'string' then
      table.insert(completion_items, v)
    elseif type(v) == 'table' then
      table.insert(completion_items, v[1])
    end
  end
  return completion_items
end


local contemplate_cmd_opts = {
  force = true,
  complete = get_completion_items,
  nargs = '?',
}

vim.api.nvim_create_user_command("Contemplate", contemplate_cmd_handler, contemplate_cmd_opts)
