# Shell 与提示符

本领域管理 Zsh 启动文件、别名和 Powerlevel10k 外观。部署前先读 [链接协议](linking.md)。

## 受管理文件

| 来源 | 目标 | 作用 |
| --- | --- | --- |
| `.zshrc` | 不部署 | Oh My Zsh、插件、别名加载和本地环境入口 |
| `.aliases` | `~/.aliases` | Git、目录、GPU 与 Conda 常用别名 |
| `.p10k.zsh` | `~/.p10k.zsh` | Powerlevel10k 提示符外观 |

## 前置条件

`.zshrc` 假定 `$HOME/.oh-my-zsh` 已存在，并启用 `aliases`、`autojump`、`zsh-autosuggestions`、`zsh-syntax-highlighting`、`git-open` 等插件。它还会加载 `$HOME/.local/bin/env`，此文件是机器本地环境入口，不属于本仓库；若缺失，部署前应报告给用户，而不是创建包含个人环境的替代文件。

上级安全规则禁止 agent 修改 `~/.zshrc`，因此它不能由本仓库的 agent 工作流部署。agent 只能报告该限制；不得通过编辑、链接、替换或生成另一个启动文件绕过它。

Powerlevel10k 主题须已安装在 Oh My Zsh 的自定义主题目录。Ghostty 配置默认使用 Nerd Font，字体设置见 [Ghostty 操作](ghostty.md)。

## 设置与验证

用户确认且目标不存在时，agent 可分别创建 `.aliases` 和 `.p10k.zsh` 的链接；它必须跳过 `.zshrc`。验证别名文件本身：

```bash
zsh -fc 'source "$HOME/.aliases"; alias glog'
```

不要在非交互 shell 中执行会修改环境的初始化命令。现有 `.zshrc` 是否加载这些文件及本机特有的 Conda、NVM、uv 等初始化，由用户自行维护。
