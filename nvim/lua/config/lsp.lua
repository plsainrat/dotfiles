local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- applies to every server, so completion works for all of them
vim.lsp.config('*', { capabilities = capabilities })

vim.lsp.config('clangd', {
  cmd = {
    'clangd',
    '--background-index',
    '--query-driver=/usr/bin/arm-none-eabi-*',
  },
})

vim.lsp.config('robotcode', {
  cmd = { '/home/pasainrat/.venvs/robotframework/bin/robotcode', 'language-server' },
  filetypes = { 'robot' },
})

vim.lsp.config('yamlls', {
  cmd = { '/full/path/from/which/yaml-language-server', '--stdio' },
})


vim.lsp.enable({ 'clangd', 'robotcode', 'bashls', 'yamlls', 'pyright', 'ruff' })

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('PaulLsp', { clear = true }),
  callback = function(args)
    local opts = { buffer = args.buf }
    local pick_lsp = require('mini.extra').pickers.lsp
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    vim.keymap.set('n', '<C-\\>', function() pick_lsp({ scope = 'definition' }) end, opts)
    vim.keymap.set('n', 'gD', function() pick_lsp({ scope = 'declaration' }) end, opts)
    vim.keymap.set('n', 'gr', function() pick_lsp({ scope = 'references' }) end, opts)
    vim.keymap.set('n', 'gi', function() pick_lsp({ scope = 'implementation' }) end, opts)
    vim.keymap.set('n', 'gy', function() pick_lsp({ scope = 'type_definition' }) end, opts)
    vim.keymap.set('n', '<leader>ss', function() pick_lsp({ scope = 'workspace_symbol' }) end, opts)

    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
    vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)

    -- clangd only: jump between foo.c and foo.h
    if client and client.name == 'clangd' then
      vim.keymap.set('n', '<leader>sh', '<cmd>LspClangdSwitchSourceHeader<CR>', opts)
    end
  end,
})
