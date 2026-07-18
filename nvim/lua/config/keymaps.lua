local map = vim.keymap.set
local opts = { silent = true }

map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit window" })
map("n", "<leader>e", "<cmd>Explore<cr>", { desc = "File explorer" })
map("n", "<leader>h", "<C-w>h", { desc = "Window left" })
map("n", "<leader>j", "<C-w>j", { desc = "Window down" })
map("n", "<leader>k", "<C-w>k", { desc = "Window up" })
map("n", "<leader>l", "<C-w>l", { desc = "Window right" })
map("n", "<leader>xx", "<cmd>copen<cr>", { desc = "Quickfix list" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Terminal normal mode" })

map("n", "<leader>tn", function()
  vim.cmd("belowright 15split | terminal")
  vim.cmd("startinsert")
end, { desc = "Terminal below" })

map("n", "<leader>cd", function()
  local directory = vim.fn.expand("%:p:h")
  if directory == "" or vim.fn.isdirectory(directory) == 0 then
    return
  end
  vim.cmd.cd(vim.fn.fnameescape(directory))
  vim.notify("Working directory: " .. vim.fn.getcwd())
end, { desc = "CD to file directory" })

map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)
