local opt = vim.opt
local state = vim.fn.stdpath("state")

for _, dir in ipairs({
  state .. "/backup",
  state .. "/swap",
  state .. "/undo",
}) do
  vim.fn.mkdir(dir, "p")
end

opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.showmode = false
opt.breakindent = true
opt.undofile = true
opt.undodir = state .. "/undo"
opt.backup = false
opt.writebackup = false
opt.swapfile = true
opt.directory = state .. "/swap"
opt.backupdir = state .. "/backup"

opt.ignorecase = true
opt.smartcase = true
opt.signcolumn = "yes"
opt.updatetime = 250
opt.timeoutlen = 500
opt.splitright = true
opt.splitbelow = true
opt.termguicolors = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.cursorline = true
opt.laststatus = 3
opt.confirm = true
opt.pumheight = 10
opt.completeopt = { "menu", "menuone", "noselect" }
opt.shortmess:append("c")
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.wildmode = "longest:full,full"

vim.cmd("filetype plugin indent on")

if vim.env.SSH_CONNECTION then
  local osc52 = require("vim.ui.clipboard.osc52")
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = osc52.copy("+"),
      ["*"] = osc52.copy("*"),
    },
    paste = {
      ["+"] = osc52.paste("+"),
      ["*"] = osc52.paste("*"),
    },
  }
end
