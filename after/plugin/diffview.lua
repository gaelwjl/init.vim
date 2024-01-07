-- remapping for diffview tool
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local api = vim.api

-- fl stands for file history
api.nvim_set_keymap("n", "<leader>fh", ":DiffviewFileHistory %<cr>", { noremap = true })
