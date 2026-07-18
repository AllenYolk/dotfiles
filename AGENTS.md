# Dotfiles 操作指南

本仓库保存可迁移的个人配置，不是安装脚本集合。受管理的配置包括：

| 领域 | 仓库来源 | 默认目标 |
| --- | --- | --- |
| Shell | `.zshrc`、`.aliases`、`.p10k.zsh` | `.zshrc` 仅供检查；可选 `~/.aliases`、`~/.p10k.zsh` |
| Git | `.gitconfig`、`.gitcommitmessage` | `~/.gitconfig`、`~/.gitcommitmessage` |
| tmux | `.tmux.conf` | `~/.tmux.conf` |
| Neovim | `nvim/init.lua`、`nvim/lua/`、`nvim/lazy-lock.json` | `~/.config/nvim/` 中对应条目 |
| Ghostty | `ghostty-config` | 见 [Ghostty 操作](docs/operations/ghostty.md) |

## 必须遵守的部署协议

1. 先阅读对应领域的操作文件，再检查仓库来源和目标路径；不得依据文件名猜测目标。
2. 每次只处理用户明确选择的一个领域，并在领域内逐个处理目标。先报告将创建的链接与已存在的冲突，取得确认后才修改；一个目标冲突不得阻止其它无冲突目标。
3. 只能为不存在的目标创建符号链接。不得使用 `ln -f`、`ln -sf`、`rm`、`unlink`、`mv` 或覆盖操作来“修复”冲突。
4. 目标已存在（无论是文件、目录或软链接）即停止该条操作，报告实际路径和 `readlink` 结果，并等待用户决定。
5. 绝不读取、复制、提交或打印私有环境文件、API key、令牌、SSH 配置或其它密钥。机器本地状态留在仓库之外。
6. 变更后只验证本次领域，并报告创建的链接、跳过项、命令及验证结果。远程机器遵循根级安全规则和 `remote_env.md`（存在时）。
7. 不得创建、替换或修改 `~/.zshrc`。这是上级安全规则禁止触碰的路径；Shell 操作只可处理 `.aliases` 和 `.p10k.zsh`，并须明确报告 `.zshrc` 未部署。

`createsymlink.sh` 已移除：它曾跨多个领域删除主目录中的链接，不能再用于部署。

## 操作文件

- [链接协议与清单](docs/operations/linking.md)：所有链接操作的前置检查、命令和回滚边界。
- [依赖矩阵](docs/operations/dependencies.md)：跨领域的必需、按需与可选第三方依赖。
- [Shell 与提示符](docs/operations/shell.md)：Zsh、Oh My Zsh、Powerlevel10k 和别名。
- [Git](docs/operations/git.md)：身份、提交模板和代理设置。
- [tmux](docs/operations/tmux.md)：TPM、剪贴板及重载。
- [Neovim](docs/operations/neovim.md)：依赖、局部链接、插件同步与验收。
- [Ghostty](docs/operations/ghostty.md)：macOS/Linux 目标目录与字体依赖。

面向最终用户的概览和选择入口在 [README.md](README.md)；Neovim 的日常快捷键见 [docs/neovim-user-guide.md](docs/neovim-user-guide.md)。
