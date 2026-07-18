# tmux 配置

本领域管理 `.tmux.conf`。部署前先读 [链接协议](linking.md)。

## 依赖

安装前先检查 [依赖矩阵](dependencies.md)。

| 级别 | 工具或服务 | 用途 | 验证 |
| --- | --- | --- | --- |
| 必需 | tmux | 加载本配置 | `tmux -V` |
| 必需 | `xterm-256color` terminfo | 本配置设置的终端类型 | `infocmp xterm-256color` |
| 按需 | TPM、Git 与网络访问 | 安装声明的 tmux 插件 | `test -x ~/.tmux/plugins/tpm/tpm` |
| 按需 | `vim-tmux-navigator`（由 TPM 安装） | 在 tmux 和 Neovim 之间导航 | TPM 插件目录存在 |
| 平台相关 | 支持 OSC52 的终端 | `set-clipboard on` 的远程复制工作流 | 在目标终端手动复制测试 |

macOS 可通过 Homebrew 安装 tmux；Linux 使用发行版包管理器。TPM 缺失时，先说明它会将插件下载到 `~/.tmux/plugins/tpm`，取得确认后再用其官方 Git 仓库安装；不得覆盖已有目录。

## 配置内容

配置启用鼠标、vi 模式窗格导航、10,000 行历史、`xterm-256color`、OSC52 相关的 `set-clipboard on`，并声明 TPM 和 `vim-tmux-navigator`。Dracula 的状态栏选项存在，但其 TPM 插件声明目前被注释，因此不会自动启用。

## 设置

确认 `tmux` 可执行，且 `~/.tmux.conf` 不存在后创建单一链接。TPM 的安装目录 `~/.tmux/plugins/tpm` 是机器本地插件状态，不受仓库管理；缺失时先报告，再由用户确认是否安装。不要因为插件目录不存在而编辑或替换 tmux 配置。

## 验证

在新的 tmux server 中加载配置：

```bash
tmux -L dotfiles-check -f "$HOME/.tmux.conf" start-server
tmux -L dotfiles-check show-options -s | grep 'set-clipboard'
tmux -L dotfiles-check kill-server
```

最后一条只关闭本次验证创建的、命名为 `dotfiles-check` 的 server；不得结束用户现有 tmux 会话。
