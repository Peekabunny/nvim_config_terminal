return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      -- Different approach for Windows Git Bash
      if vim.fn.has 'win32' == 1 then
        -- Use cmd.exe with /c to launch bash properly on Windows
        vim.o.shell = 'cmd.exe'
        vim.o.shellcmdflag = '/c'
        -- Using 'bash' from PATH if it's in your PATH, or use full path if needed
        vim.o.shellxquote = ''
      end

      require('toggleterm').setup {
        size = 12,
        open_mapping = [[<F12>]],
        direction = 'horizontal',
        -- On Windows, we'll use a special command to properly launch bash
        shell = vim.fn.has 'win32' == 1 and 'bash.exe' or vim.o.shell,
        -- No additional shell arguments for now
        close_on_exit = true,
        persist_mode = true,
        start_in_insert = false, -- Don't automatically enter insert mode
        on_exit = function(term, job_id, exit_code, name)
          if exit_code ~= 0 then
            vim.notify(string.format('Terminal %s exited (Code: %d)', name, exit_code), vim.log.levels.WARN)
          end
        end,
      }

      -- Auto-open terminal when Neovim starts
      vim.api.nvim_create_autocmd({ 'VimEnter' }, {
        callback = function()
          -- Wait a bit to ensure Neovim is fully loaded
          vim.defer_fn(function()
            -- Toggle terminal open (using terminal 1)
            require('toggleterm').toggle(1)
            -- Focus back to the main editor after opening terminal
            vim.cmd 'wincmd p' -- Go back to the previous window
          end, 100)            -- 100ms delay
        end,
      })

      -- Terminal keymaps (optional)
      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
      end

      -- Auto command to set terminal keymaps when terminal opens
      vim.cmd 'autocmd! TermOpen term://* lua set_terminal_keymaps()'

      -- Additional utility functions for terminal control
      -- Function to toggle terminal or create if it doesn't exist
      function _G.toggle_terminal()
        local term = require 'toggleterm'
        term.toggle(1)
      end

      -- Add a command to toggle terminal
      vim.api.nvim_create_user_command('TermToggle', toggle_terminal, { desc = 'Toggle terminal' })

      -- Auto-close terminal when exiting Neovim
      -- This ensures terminal processes are killed when you quit
      vim.api.nvim_create_autocmd({ 'QuitPre' }, {
        callback = function()
          -- Get the Terminal module directly
          local Terminal = require 'toggleterm.terminal'
          if Terminal then
            -- Get all terminals using the correct API
            local terminals = Terminal.get_all()
            if terminals then
              for _, term in pairs(terminals) do
                if term and term:is_open() then
                  term:close()
                end
              end
            end
          end
        end,
      })
    end,
  },
}
