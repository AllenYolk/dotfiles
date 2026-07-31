local M = {}

local function read_env_key(path, target_name)
  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok then
    return nil
  end

  for _, line in ipairs(lines) do
    local name, value = line:match("^%s*export%s+([%w_]+)%s*=%s*(.-)%s*$")
    if not name then
      name, value = line:match("^%s*([%w_]+)%s*=%s*(.-)%s*$")
    end
    if name == target_name then
      return value:match('^"(.*)"$') or value:match("^'(.*)'$") or value
    end
  end
end

function M.minimax_api_key()
  if vim.env.MINIMAX_CN_API_KEY and vim.env.MINIMAX_CN_API_KEY ~= "" then
    return vim.env.MINIMAX_CN_API_KEY
  end

  for _, path in ipairs({
    "~/.codex/.env",
    "~/.hermes/.env",
    "~/.local/bin/env",
  }) do
    local key = read_env_key(vim.fn.expand(path), "MINIMAX_CN_API_KEY")
    if key and key ~= "" then
      return key
    end
  end
end

return M
