local treesitter = require("nvim-treesitter")
local languages = {
  "bash",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "vim",
  "vimdoc",
}

treesitter.setup({
  install_dir = vim.fn.stdpath("data") .. "/site",
})

local installed = {}
for _, language in ipairs(treesitter.get_installed()) do
  installed[language] = true
end

local missing = {}
for _, language in ipairs(languages) do
  if not installed[language] then
    table.insert(missing, language)
  end
end
if #missing > 0 then
  treesitter.install(missing)
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("TreesitterFeatures", { clear = true }),
  pattern = languages,
  callback = function()
    pcall(vim.treesitter.start)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
