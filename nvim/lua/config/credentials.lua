local M = {}

function M.opencode_go_api_key()
  if vim.env.OPENCODE_GO_API_KEY and vim.env.OPENCODE_GO_API_KEY ~= "" then
    return vim.env.OPENCODE_GO_API_KEY
  end

  local ok, lines = pcall(vim.fn.readfile, vim.fn.expand("~/.Hermes/.env"))
  if not ok then
    return nil
  end

  for _, line in ipairs(lines) do
    local name, value = line:match("^%s*export%s+([%w_]+)%s*=%s*(.-)%s*$")
    if not name then
      name, value = line:match("^%s*([%w_]+)%s*=%s*(.-)%s*$")
    end
    if name == "OPENCODE_GO_API_KEY" then
      return value:match('^"(.*)"$') or value:match("^'(.*)'$") or value
    end
  end
end

return M
