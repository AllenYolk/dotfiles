# 经典 Vim 配置

`.vimrc` 是独立的经典 Vim 配置，使用 Vundle 和 `vim-wakatime`；它与 Neovim 配置互不依赖。部署前先读 [链接协议](linking.md)。

## 设置

用户确认且 `~/.vimrc` 不存在后，创建单一链接。Vundle 的目录 `~/.vim/bundle/Vundle.vim` 和下载的插件均为机器本地状态，不由本仓库管理。

若用户选择继续使用经典 Vim，再确认 Vundle 已安装，随后在交互 Vim 中运行 `:PluginInstall`。该操作会下载插件，必须先说明网络影响。没有明确需求时，优先部署 Neovim，不要同时安装两套插件管理器来解决缺失依赖。

## 验证

```bash
vim -Nu "$HOME/.vimrc" -n '+qa!'
```

只报告启动结果；不要为了消除启动错误而写入用户目录或删除现有 Vim 插件。
