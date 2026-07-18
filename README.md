# dotfiles

这是 Linux 与 macOS 共用的个人配置仓库，覆盖 Zsh、Git、tmux、Neovim 和 Ghostty。它保存的是配置源，而不是一键安装器：每台机器都可能已有本地文件、私有凭据和工具状态，部署必须按配置领域单独判断。

## 使用方式

克隆仓库后，不要运行批量软链接脚本（该脚本已移除）。选择需要的配置，然后让具备终端访问权限的 agent 先阅读仓库根目录的 [AGENTS.md](AGENTS.md)，再按对应操作文件检查、报告冲突并取得确认后创建链接。

可以直接给 agent 如下任务：

```text
请部署此 dotfiles 仓库中的 Neovim 配置。先阅读 AGENTS.md 和 docs/operations/neovim.md，列出目标路径与冲突；在我确认前不要修改任何文件。
```

这个流程不会自动覆盖现有文件、替换他人软链接或同步密钥。仓库只管理明确列出的配置项；插件目录、缓存、私有 `.env`、WakaTime 设置及机器本地环境仍留在目标机器上。

## 配置入口

| 配置 | 内容 | 设置说明 |
| --- | --- | --- |
| Shell | Zsh、Oh My Zsh 别名和 Powerlevel10k | [Shell 与提示符](docs/operations/shell.md)（agent 不修改 `~/.zshrc`） |
| Git | 身份、Neovim 编辑器和提交模板 | [Git](docs/operations/git.md) |
| tmux | 窗格导航、剪贴板和 TPM 插件声明 | [tmux](docs/operations/tmux.md) |
| Neovim | Python/Markdown 开发、终端和 AI 补全 | [Neovim 设置](docs/operations/neovim.md) · [使用手册](docs/neovim-user-guide.md) |
| Ghostty | 主题、字体和 SSH shell integration | [Ghostty](docs/operations/ghostty.md) |

所有链接的来源与目标路径见 [链接协议与清单](docs/operations/linking.md)。
安装前的第三方依赖清单见 [依赖矩阵](docs/operations/dependencies.md)。

## 注意事项

- `.gitconfig` 包含个人身份；部署到不同身份的机器前务必确认。
- Git 代理属于机器或会话设置，不应写回此仓库；否则没有 VPN 的机器可能无法访问 GitHub。
- Neovim 的 AI 补全会读取机器本地凭据并发送编辑上下文给 OpenCode Go。密钥不属于本仓库。
