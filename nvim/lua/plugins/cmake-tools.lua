return {
  'Civitasv/cmake-tools.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('cmake-tools').setup {
      cmake_command = 'cmake',
      cmake_build_directory = 'build',
      cmake_build_type = 'Debug',
      cmake_generate_options = { '-G', 'Ninja' }, -- Optional
      cmake_regenerate_on_save = true,
      cmake_console_size = 10,
      cmake_show_console = 'always',
    }

    -- Keybindings
    vim.keymap.set('n', '<leader>cg', '<cmd>CMakeGenerate<CR>', { desc = 'CMake Generate' })
    vim.keymap.set('n', '<leader>cb', '<cmd>CMakeBuild<CR>', { desc = 'CMake Build' })
    vim.keymap.set('n', '<leader>cr', '<cmd>CMakeRun<CR>', { desc = 'CMake Run Target' })
    vim.keymap.set('n', '<leader>cc', '<cmd>CMakeClean<CR>', { desc = 'CMake Clean' })
  end,
  ft = { 'cpp', 'c', 'cmake' },
}
