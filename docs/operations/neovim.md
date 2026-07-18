# Neovim Configuration

This domain manages only `nvim/init.lua`, `nvim/lua/`, and `nvim/lazy-lock.json`. Daily editing instructions are in the [Neovim User Guide](../neovim-user-guide.md). Read the [Linking Protocol](linking.md) before deployment.

## Dependencies

The table below is derived from the configured plugins, LSP servers, formatters, and startup logic. A missing dependency degrades the related workflow or can cause the first startup to fail.

| Level | Tool or service | Configuration use | Verification |
| --- | --- | --- | --- |
| Required | Neovim >= 0.11 | `vim.lsp.config`, `vim.lsp.enable`, and all Lua configuration | `nvim --version` |
| Required | `git` and network access | Initial lazy.nvim clone; `Lazy sync` downloads locked plugins | `git --version` |
| Required | C compiler, `tree-sitter` CLI, `curl`, `tar` | Downloads, extracts, and installs missing Bash, JSON, Lua, Markdown, Python, and Vim parsers at startup | `cc --version`, `tree-sitter --version`, `curl --version`, `tar --version` |
| Search workflow | `rg`, `fd`, `fzf` | Live grep, file enumeration, and fzf-lua pickers | `rg --version`, `fd --version`, `fzf --version` |
| Python workflow | `uv`, `ruff`, `basedpyright-langserver` | uv provisions tools; Ruff formats and lints; basedpyright provides Python LSP | `uv --version`, `ruff --version`, `basedpyright-langserver --version` |
| Markdown workflow | `marksman` | Markdown LSP | `marksman --version` |
| Optional | Rust/Cargo | Local blink.cmp native fuzzy-backend build when a prebuilt backend is unavailable | `cargo --version` |
| Optional | Nerd Font | Icons in nvim-web-devicons, blink.cmp, and terminal UI | Inspect icons in the terminal |
| Optional | WakaTime CLI and private `~/.wakatime.cfg` | `vim-wakatime` activity tracking | `~/.wakatime/wakatime-cli --version` |
| Optional | `OPENCODE_GO_API_KEY` and OpenCode Go network access | Minuet AI completion; no OpenCode command-line client is required | Check that the variable exists without printing its value |
| Platform-specific | Clipboard provider | Local `unnamedplus`; OSC52 is selected automatically over SSH | macOS uses the system clipboard; Linux needs a provider appropriate for X11 or Wayland |

On macOS, Homebrew can install the base tools:

```bash
brew install neovim git ripgrep fd fzf tree-sitter marksman curl
```

Install a C compiler through Xcode Command Line Tools. Always provision Python tools with `uv`, never system `pip`:

```bash
uv tool install ruff
uv tool install basedpyright
```

On Linux, use the distribution package manager for Neovim, Git, ripgrep, fd, fzf, the Tree-sitter CLI, a C compiler, `curl`, `tar`, and marksman. Package names vary; where `fd-find` exposes only `fdfind`, install a compatible package that provides `fd`. Then use the same `uv tool install` commands for Ruff and basedpyright. Obtain confirmation before downloading plugins, system packages, or parsers.

The first startup installs lazy.nvim in Neovim's data directory. `~/.config/nvim/.env`, `~/.hermes/.env`, WakaTime configuration, and project virtual environments are machine-local private state. Never read, copy, or link them.

## Setup

1. Check `~/.config/nvim`: create an empty directory only if it is absent; preserve it when it already exists.
2. Inspect the three individual targets: `init.lua`, `lazy-lock.json`, and `lua`. Skip and report each occupied target; never replace it.
3. Create links only for absent targets. Do not link the entire `nvim/` directory to `~/.config/nvim`.
4. After confirming that plugin sources are reachable and that network writes are approved, run `nvim --headless '+Lazy! sync' '+qa!'`. This downloads plugins.

## Verification

First run static checks that do not load configuration or trigger downloads:

```bash
nvim --version
test -f "$HOME/.config/nvim/init.lua"
```

Full startup loads `lazy.lua` and Tree-sitter configuration. It can clone or download content when lazy.nvim or parsers are missing, so run it only after the user has approved network writes:

```bash
nvim --headless -u "$HOME/.config/nvim/init.lua" '+qa!'
```

Report the Neovim version, dependency checks, status of the three links, and plugin synchronization result. On failure, retain the output and diagnose it; do not remove Neovim data or private `.env` files.

On remote machines, follow the root `AGENTS.md` remote workflow separately and record host, commit, command, and result. Never copy local binaries or plugins to another operating system.
