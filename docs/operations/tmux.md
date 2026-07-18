# tmux 配置

本领域管理 `.tmux.conf`。部署前先读 [链接协议](linking.md)。

## 配置内容

配置启用鼠标、vi 模式窗格导航、10,000 行历史、`xterm-256color`、OSC52 相关的 `set-clipboard on`，并声明 TPM、`vim-tmux-navigator` 及 Dracula 状态栏插件。

## 设置

确认 `tmux` 可执行，且 `~/.tmux.conf` 不存在后创建单一链接。TPM 的安装目录 `~/.tmux/plugins/tpm` 是机器本地插件状态，不受仓库管理；缺失时先报告，再由用户确认是否安装。不要因为插件目录不存在而编辑或替换 tmux 配置。

## 验证

在新的 tmux server 中加载配置：

```bash
tmux -L dotfiles-check -f "$HOME/.tmux.conf" start-server
tmux -L dotfiles-check show-options -s | rg 'set-clipboard'
tmux -L dotfiles-check kill-server
```

最后一条只关闭本次验证创建的、命名为 `dotfiles-check` 的 server；不得结束用户现有 tmux 会话。
