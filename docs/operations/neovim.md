# Neovim 配置

本领域只管理 `nvim/init.lua`、`nvim/lua/` 和 `nvim/lazy-lock.json`。完整的编辑使用说明在 [Neovim 使用手册](../neovim-user-guide.md)。部署前先读 [链接协议](linking.md)。

## 前置条件

配置要求 Neovim 0.11 或更高版本，并通过 lazy.nvim 管理插件。常用外部工具是 `git`、`rg`、`fd`、`fzf`、`tree-sitter`、`ruff`、`basedpyright-langserver` 和 `marksman`。Python 工具使用 `uv` 安装；不要用系统 `pip`。

该配置会在首次启动时把 lazy.nvim 安装到 Neovim 数据目录。`~/.config/nvim/.env`、`~/.hermes/.env`、WakaTime 配置和项目虚拟环境均是本机私有状态，不得读取、复制或纳入链接。

## 设置

1. 检查 `~/.config/nvim`：若不存在，可创建空目录；若已存在则保留它。
2. 分别检查 `init.lua`、`lazy-lock.json` 和 `lua` 三个目标。任意一个目标存在即跳过该项并报告，不能替换。
3. 仅为不存在的目标逐项创建链接。不要将整个 `nvim/` 目录链接到 `~/.config/nvim`。
4. 确认插件来源可访问后执行 `nvim --headless '+Lazy! sync' '+qa!'`。此步骤会下载插件，应先得到用户对网络访问的确认。

## 验证

```bash
nvim --version
nvim --headless -u "$HOME/.config/nvim/init.lua" '+qa!'
```

报告 Neovim 版本、三个目标的链接状态和插件同步结果。若启动失败，保留失败输出，停止并诊断；不要删除 Neovim 数据目录或用户的 `.env` 文件。

远程机器上须按根级 `AGENTS.md` 的远程工作流单独执行并记录主机、commit、命令和结果；不要把本机插件或二进制复制过去。
