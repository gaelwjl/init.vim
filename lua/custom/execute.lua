local api = vim.api

api.nvim_create_user_command('CompileRun', 'execute "!g++ % -std=c++17 -D=CP_DEBUG -o %< && ./%"', {})
