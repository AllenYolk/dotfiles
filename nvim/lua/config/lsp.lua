local lsp = vim.lsp

local function on_attach(_, buffer)
  local map = function(keys, action, description)
    vim.keymap.set("n", keys, action, { buffer = buffer, desc = description })
  end

  map("gd", lsp.buf.definition, "Go to definition")
  map("gD", lsp.buf.declaration, "Go to declaration")
  map("gr", lsp.buf.references, "Find references")
  map("K", lsp.buf.hover, "Hover documentation")
  map("<leader>rn", lsp.buf.rename, "Rename symbol")
  map("<leader>ca", lsp.buf.code_action, "Code action")
  map("<leader>D", lsp.buf.type_definition, "Go to type definition")
  map("<leader>dd", vim.diagnostic.open_float, "Diagnostic details")
end

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

local python_root_markers = {
  "pyproject.toml",
  "uv.lock",
  "setup.py",
  "setup.cfg",
  "requirements.txt",
  ".python-version",
  ".git",
}

lsp.config("basedpyright", {
  on_attach = on_attach,
  root_markers = python_root_markers,
  before_init = function(_, config)
    local root = config.root_dir
    if type(root) ~= "string" then
      return
    end

    for _, name in ipairs({ ".venv", "venv" }) do
      local python = root .. "/" .. name .. "/bin/python"
      if vim.uv.fs_stat(python) then
        config.settings = config.settings or {}
        config.settings.python = config.settings.python or {}
        config.settings.python.pythonPath = python
        return
      end
    end
  end,
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true,
      },
    },
  },
})

lsp.config("marksman", {
  on_attach = on_attach,
})

lsp.enable({ "basedpyright", "marksman" })
