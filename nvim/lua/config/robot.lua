-- Reconnaître les fichiers Robot Framework
vim.filetype.add({
  extension = {
    robot = 'robot',
    resource = 'robot',
  },
})

-- Configuration spécifique aux fichiers Robot Framework
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'robot',
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = true
    vim.opt_local.commentstring = '# %s'
  end,
})

-- Robot Framework Language Server
local robot_lsp = vim.fn.expand(
    "~/.venvs/robotframework/bin/robotframework_ls"
)

vim.api.nvim_create_autocmd("FileType", {
    pattern = "robot",
    callback = function(args)
        local root = vim.fs.root(args.buf, {
            ".git",
            "robot.yaml",
            "pyproject.toml",
        }) or vim.fn.getcwd()

        vim.lsp.start({
            name = "robotframework_ls",
            cmd = { robot_lsp },
            root_dir = root,
        }, {
            bufnr = args.buf,
        })
    end,
})

