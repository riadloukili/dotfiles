-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local arg = vim.fn.argv(0) --[[@as string]]
    if arg and arg ~= "" then
      if vim.fn.isdirectory(arg) == 1 then
        vim.cmd.cd(arg)
      elseif vim.fn.filereadable(arg) == 1 then
        vim.cmd.cd(vim.fn.fnamemodify(arg, ":h"))
      end
    end
  end,
})
