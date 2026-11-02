local function find_python(root)
  -- 1. an activated venv wins
  local venv = vim.env.VIRTUAL_ENV
  if venv and venv ~= '' then
    return venv .. '/bin/python'
  end
  -- 2. a venv folder inside the project
  for _, name in ipairs({ '.venv', 'venv', 'env' }) do
    local candidate = root .. '/' .. name .. '/bin/python'
    if vim.fn.executable(candidate) == 1 then
      return candidate
    end
  end
  -- 3. system python
  return vim.fn.exepath('python3')
end

vim.lsp.config('pyright', {
  settings = {
    pyright = { disableOrganizeImports = true },  -- ruff sorts imports
  },
  before_init = function(_, config)
    local python = find_python(config.root_dir or vim.fn.getcwd())
    if python ~= '' then
      config.settings = vim.tbl_deep_extend('force', config.settings or {}, {
        python = { pythonPath = python },
      })
    end
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == 'ruff' then
      client.server_capabilities.hoverProvider = false  -- pyright owns K
    end
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    vim.opt_local.foldmethod = 'indent'
    vim.opt_local.foldlevel = 99
  end,
})
