# Shell 与提示符

本领域管理 Zsh 启动文件、别名和 Powerlevel10k 外观。部署前先读 [链接协议](linking.md)。

## 受管理文件

| 来源 | 目标 | 作用 |
| --- | --- | --- |
| `.zshrc` | `~/.zshrc` | Oh My Zsh、插件、别名加载和本地环境入口 |
| `.aliases` | `~/.aliases` | Git、目录、GPU 与 Conda 常用别名 |
| `.p10k.zsh` | `~/.p10k.zsh` | Powerlevel10k 提示符外观 |

## 前置条件

`.zshrc` 假定 `$HOME/.oh-my-zsh` 已存在，并启用 `aliases`、`autojump`、`zsh-autosuggestions`、`zsh-syntax-highlighting`、`git-open` 等插件。它还会加载 `$HOME/.local/bin/env`，此文件是机器本地环境入口，不属于本仓库；若缺失，部署前应报告给用户，而不是创建包含个人环境的替代文件。

Powerlevel10k 主题须已安装在 Oh My Zsh 的自定义主题目录。Ghostty 配置默认使用 Nerd Font，字体设置见 [Ghostty 操作](ghostty.md)。

## 设置与验证

用户确认且三个目标均不存在时，逐条创建链接。新开一个 Zsh 会话后验证：

```bash
zsh -ic 'alias glog; print -r -- $ZSH_THEME'
```

不要在非交互 shell 中执行会修改环境的初始化命令。确认 `.zshrc` 能加载后，再由用户自行处理本机特有的 Conda、NVM、uv 或其它工具初始化。
