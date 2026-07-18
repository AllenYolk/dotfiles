# Shell 与提示符

本领域管理 Zsh 启动文件、别名和 Powerlevel10k 外观。部署前先读 [链接协议](linking.md)。

## 受管理文件

| 来源 | 目标 | 作用 |
| --- | --- | --- |
| `.zshrc` | 不部署 | Oh My Zsh、插件、别名加载和本地环境入口 |
| `.aliases` | `~/.aliases` | Git、目录、GPU 与 Conda 常用别名 |
| `.p10k.zsh` | `~/.p10k.zsh` | Powerlevel10k 提示符外观 |

## 依赖

安装前先检查 [依赖矩阵](dependencies.md)。`.zshrc` 依赖如下组件：

| 级别 | 工具或服务 | 用途 |
| --- | --- | --- |
| 必需 | Zsh、Oh My Zsh | 启动 shell 和加载主题/插件 |
| 必需 | Powerlevel10k | `.p10k.zsh` 的主题实现 |
| 必需 | `$HOME/.local/bin/env` | 机器本地环境入口；不属于仓库，agent 不得创建或读取内容 |
| 必需 | `zsh-autosuggestions`、`zsh-syntax-highlighting`、`git-open`、`zsh-vi-mode` Oh My Zsh custom plugins | `.zshrc` 显式启用的第三方插件 |
| 按需 | `autojump` | Oh My Zsh 的 `autojump` 插件所调用的命令 |
| 别名按需 | `git`、`fzf`、`nvim` | Git 别名、`lf` 和 `vrc` |
| 别名按需 | `tldr`、`watch`、`nvidia-smi`、`nvitop`、`conda`、`citation_refiner` | 仅在执行对应别名或函数时需要；`tldr` 只在主机名为 `bogon` 时参与启动 |

macOS 可通过 Homebrew 安装 `zsh`、`autojump`、`fzf` 和 Git；`nvitop` 使用 `uv tool install nvitop`。Oh My Zsh、Powerlevel10k 与 custom plugins 应安装到用户已有的 Oh My Zsh 目录，安装来源必须经用户确认，且不得执行 `curl | sh` 一类远程脚本。`citation_refiner` 是用户自备命令，本仓库不提供安装来源。

上级安全规则禁止 agent 修改 `~/.zshrc`，因此它不能由本仓库的 agent 工作流部署。agent 只能报告该限制；不得通过编辑、链接、替换或生成另一个启动文件绕过它。

Powerlevel10k 主题须已安装在 Oh My Zsh 的自定义主题目录。Ghostty 配置默认使用 Nerd Font，字体设置见 [Ghostty 操作](ghostty.md)。

## 设置与验证

用户确认且目标不存在时，agent 可分别创建 `.aliases` 和 `.p10k.zsh` 的链接；它必须跳过 `.zshrc`。验证别名文件本身：

```bash
zsh -fc 'source "$HOME/.aliases"; alias glog'
```

不要在非交互 shell 中执行会修改环境的初始化命令。现有 `.zshrc` 是否加载这些文件及本机特有的 Conda、NVM、uv 等初始化，由用户自行维护。
