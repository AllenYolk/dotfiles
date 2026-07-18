# Neovim 配置

本领域只管理 `nvim/init.lua`、`nvim/lua/` 和 `nvim/lazy-lock.json`。完整的编辑使用说明在 [Neovim 使用手册](../neovim-user-guide.md)。部署前先读 [链接协议](linking.md)。

## 依赖

安装前先检查 [依赖矩阵](dependencies.md)。下表由 `nvim/` 中实际插件、LSP、格式化器和启动逻辑得出；缺少项会导致对应功能降级或首次启动失败。

| 级别 | 工具或服务 | 配置中的用途 | 验证 |
| --- | --- | --- | --- |
| 必需 | Neovim >= 0.11 | `vim.lsp.config`、`vim.lsp.enable` 与全部 Lua 配置 | `nvim --version` |
| 必需 | `git` 与网络访问 | 首次克隆 lazy.nvim，`Lazy sync` 下载锁定插件 | `git --version` |
| 必需 | C 编译器和 `tree-sitter` CLI | 启动时自动安装缺失的 Bash、JSON、Lua、Markdown、Python、Vim parser | `cc --version`、`tree-sitter --version` |
| 搜索工作流 | `rg`、`fd`、`fzf` | 分别支持全文搜索、文件枚举和 fzf-lua 选择界面 | `rg --version`、`fd --version`、`fzf --version` |
| Python 工作流 | `uv`、`ruff`、`basedpyright-langserver` | `uv` 负责安装工具；Ruff 格式化/lint，basedpyright 提供 Python LSP | `uv --version`、`ruff --version`、`basedpyright-langserver --version` |
| Markdown 工作流 | `marksman` | Markdown LSP | `marksman --version` |
| 可选 | Rust/Cargo | blink.cmp 在预编译 native fuzzy backend 不可用时的本地构建路径；缺失时会回退并提示 | `cargo --version` |
| 可选 | Nerd Font | nvim-web-devicons、blink.cmp 和终端 UI 的图标显示 | 在终端中检查图标是否正常显示 |
| 可选 | WakaTime CLI 与私有 `~/.wakatime.cfg` | `vim-wakatime` 记录编辑活动 | `~/.wakatime/wakatime-cli --version` |
| 可选 | `OPENCODE_GO_API_KEY` 与 OpenCode Go 网络访问 | Minuet AI 补全；不需要 OpenCode 命令行 | 只确认环境变量存在，禁止打印值 |
| 平台相关 | 剪贴板 provider | 本机 `unnamedplus`；SSH 时配置自动使用 OSC52 | macOS 使用系统剪贴板；Linux 安装适配 X11/Wayland 的 provider |

macOS 可用 Homebrew 安装基础工具：

```bash
brew install neovim git ripgrep fd fzf tree-sitter marksman
```

安装 C 编译器使用系统的 Xcode Command Line Tools。Python 工具始终用 `uv`，不要用系统 `pip`：

```bash
uv tool install ruff
uv tool install basedpyright
```

Linux 使用发行版包管理器安装 Neovim、Git、ripgrep、fd、fzf、Tree-sitter CLI、C 编译器和 marksman；包名会随发行版变化，`fd-find` 只提供 `fdfind` 时需要安装提供 `fd` 命令的兼容包或替代包。再用相同的 `uv tool install` 命令安装 Ruff 和 basedpyright。下载插件、系统包或 parser 前必须先取得用户确认。

该配置会在首次启动时把 lazy.nvim 安装到 Neovim 数据目录。`~/.config/nvim/.env`、`~/.hermes/.env`、WakaTime 配置和项目虚拟环境均是本机私有状态，不得读取、复制或纳入链接。

## 设置

1. 检查 `~/.config/nvim`：若不存在，可创建空目录；若已存在则保留它。
2. 分别检查 `init.lua`、`lazy-lock.json` 和 `lua` 三个目标。任意一个目标存在即跳过该项并报告，不能替换。
3. 仅为不存在的目标逐项创建链接。不要将整个 `nvim/` 目录链接到 `~/.config/nvim`。
4. 确认插件来源可访问后执行 `nvim --headless '+Lazy! sync' '+qa!'`。此步骤会下载插件，应先得到用户对网络访问的确认。

## 验证

先进行不会加载配置、不会触发下载的静态检查：

```bash
nvim --version
test -f "$HOME/.config/nvim/init.lua"
```

完整启动验证会加载 `lazy.lua` 和 Tree-sitter 配置；若 lazy.nvim 或 parser 缺失，它可能克隆或下载内容。因此只有在用户已确认网络写入后才可执行：

```bash
nvim --headless -u "$HOME/.config/nvim/init.lua" '+qa!'
```

报告 Neovim 版本、依赖检查、三个目标的链接状态和插件同步结果。若启动失败，保留失败输出，停止并诊断；不要删除 Neovim 数据目录或用户的 `.env` 文件。

远程机器上须按根级 `AGENTS.md` 的远程工作流单独执行并记录主机、commit、命令和结果；不要把本机插件或二进制复制过去。
