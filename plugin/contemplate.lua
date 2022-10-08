local has_telescope = pcall(require, 'telescope')

if has_telescope then
  vim.api.nvim_create_user_command('Contemplate', 'Telescope contemplate', { force = true })
end
