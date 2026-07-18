# 依赖矩阵

本页汇总仓库配置实际引用的第三方工具和服务。它不是自动安装清单：agent 必须先检查版本与现有状态、说明网络和系统改动，并在用户确认后才安装缺失项。每个领域的安装细节和验收命令在对应操作文件中。

| 领域 | 必需依赖 | 按需或可选依赖 | 详细说明 |
| --- | --- | --- | --- |
| Shell | Zsh、Oh My Zsh、Powerlevel10k、`$HOME/.local/bin/env`、四个启用的 custom plugins | autojump、Git、fzf、Neovim、GPU/Conda/自定义别名工具 | [Shell 与提示符](shell.md) |
| Git | Git、Neovim（`core.editor=nvim`） | 无 | [Git](git.md) |
| tmux | tmux、`xterm-256color` terminfo | TPM、Git、网络、vim-tmux-navigator、OSC52 终端 | [tmux](tmux.md) |
| Neovim | Neovim >= 0.11、Git、网络、C 编译器、Tree-sitter CLI、`rg`、`fd`、`fzf`、uv、Ruff、basedpyright、marksman | Rust/Cargo、Nerd Font、WakaTime、OpenCode Go 凭据、Linux 剪贴板 provider | [Neovim](neovim.md) |
| Ghostty | Ghostty、MesloLGS NF 字体 | SSH/terminfo 支持 | [Ghostty](ghostty.md) |

`uv` 是本仓库唯一允许用于安装 Python 工具与解释器的依赖管理器；不得用系统 `pip`。私有环境文件、API key、WakaTime 配置、SSH 配置和机器本地状态永远不在依赖安装或同步范围内。
