local M = {}

local function read_env_key(path)
  local ok, lines = pcall(vim.fn.readfile, path)
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

function M.opencode_go_api_key()
  if vim.env.OPENCODE_GO_API_KEY and vim.env.OPENCODE_GO_API_KEY ~= "" then
    return vim.env.OPENCODE_GO_API_KEY
  end

  local credential_files = {
    vim.fn.expand("~/.config/nvim/.env"),
    vim.fn.expand("~/.hermes/.env"),
  }
  if vim.env.OPENCODE_GO_API_KEY_FILE and vim.env.OPENCODE_GO_API_KEY_FILE ~= "" then
    table.insert(credential_files, 1, vim.env.OPENCODE_GO_API_KEY_FILE)
  end

  for _, path in ipairs(credential_files) do
    local key = read_env_key(path)
    if key then
      return key
    end
  end
end

return M
