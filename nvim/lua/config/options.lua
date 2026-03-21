-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.autoformat = false

vim.opt.relativenumber = true

vim.keymap.set('i', 'jj', '<Esc>', { desc = 'Salir de modo insert', nowait = true })

-- Agregar Mason al PATH para que nvim encuentre los LSP servers
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH
