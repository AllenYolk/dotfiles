# 链接协议与清单

本仓库不提供批量部署脚本。agent 必须一次处理一个配置领域，并只为不存在的目标创建链接。这样可以保留每台机器的本地文件、私有凭据和软件状态。

## 前置检查

从仓库根目录运行下列只读检查，并将结果报给用户：

```bash
repo=$(git rev-parse --show-toplevel)
test -f "$repo/.zshrc"
test -d "$repo/nvim"
```

对每个计划创建的目标，先执行 `test -e "$target" -o -L "$target"`。返回成功即表示目标已被占用，不能改动它。软链接的状态可用 `readlink "$target"` 仅供报告。

## 创建规则

目标不存在且用户确认后，使用精确的单条命令创建相对或绝对链接，例如：

```bash
ln -s "$repo/.tmux.conf" "$HOME/.tmux.conf"
```

不得使用强制选项，也不得在一条命令里处理多个领域。同一领域的每个目标也独立确认、创建或跳过：一个目标冲突只停止该目标，不能阻止其余无冲突目标。Neovim 的目录和逐项链接规则见 [Neovim 操作](neovim.md)。

## 受管理清单

| 领域 | 来源 | 目标 |
| --- | --- | --- |
| Shell | `.aliases` | `~/.aliases` |
| Shell | `.p10k.zsh` | `~/.p10k.zsh` |
| Git | `.gitconfig` | `~/.gitconfig` |
| Git | `.gitcommitmessage` | `~/.gitcommitmessage` |
| tmux | `.tmux.conf` | `~/.tmux.conf` |
| Vim | `.vimrc` | `~/.vimrc` |
| Neovim | `nvim/init.lua` | `~/.config/nvim/init.lua` |
| Neovim | `nvim/lazy-lock.json` | `~/.config/nvim/lazy-lock.json` |
| Neovim | `nvim/lua` | `~/.config/nvim/lua` |

Ghostty 目标随操作系统而变，单独见 [Ghostty 操作](ghostty.md)。

`.zshrc` 是仓库来源但不是可部署条目：上级安全规则禁止 agent 修改 `~/.zshrc`。agent 只能报告其存在，不能创建、替换或链接它。

## 冲突与回滚

若目标存在，停止该条操作。报告来源、目标和目标类型；不要备份、移动、删除或替换，除非用户对具体路径另行明确授权。

若本次刚创建的链接需要回滚，先向用户列出准确路径，取得确认后才解除该单一链接。绝不递归删除目录，也不改动与本仓库无关的链接。
