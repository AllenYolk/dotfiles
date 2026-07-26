local lsp = vim.lsp

local capabilities = lsp.protocol.make_client_capabilities()
local blink_ok, blink = pcall(require, "blink.cmp")
if blink_ok then
  capabilities = blink.get_lsp_capabilities(capabilities)
end

local function on_attach(_, buffer)
  local map = function(keys, action, description)
    vim.keymap.set("n", keys, action, { buffer = buffer, silent = true, desc = description })
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

vim.diagnostic.config({
  underline = true,
  severity_sort = true,
  virtual_text = { spacing = 2, source = "if_many" },
  float = { border = "rounded", source = "if_many" },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN] = "W",
      [vim.diagnostic.severity.INFO] = "I",
      [vim.diagnostic.severity.HINT] = "H",
    },
  },
})

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { silent = true, desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { silent = true, desc = "Next diagnostic" })

local python_root_markers = {
  "pyproject.toml",
  "uv.lock",
  "setup.py",
  "setup.cfg",
  "requirements.txt",
  "Pipfile",
  "poetry.lock",
  ".python-version",
  ".git",
}

lsp.config("basedpyright", {
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { "python" },
  on_attach = on_attach,
  root_markers = python_root_markers,
  capabilities = capabilities,
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
        config.settings.python.venvPath = root
        config.settings.python.venv = name
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
        typeCheckingMode = "basic",
      },
    },
  },
})

lsp.config("marksman", {
  cmd = { "marksman", "server" },
  filetypes = { "markdown" },
  on_attach = on_attach,
  root_markers = { ".marksman.toml", ".git" },
  capabilities = capabilities,
})

lsp.enable({ "basedpyright", "marksman" })
