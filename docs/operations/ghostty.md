# Ghostty 配置

仓库文件 `ghostty-config` 设置 Catppuccin Macchiato、MesloLGS NF 12pt 字体，以及 SSH shell integration。它不包含密钥或主机信息。

## 目标路径

Ghostty 的目标文件因平台而异，必须先用 `ghostty +show-config --default --docs` 或本机安装文档确认：

| 平台 | 常见目标 |
| --- | --- |
| macOS | `~/Library/Application Support/com.mitchellh.ghostty/config` |
| Linux（XDG） | `$XDG_CONFIG_HOME/ghostty/config`；未设置时为 `$HOME/.config/ghostty/config` |

目标只作参考；agent 必须检查实际 Ghostty 安装和目标位置，不能创建猜测的目录树。

## 设置与验证

用户确认的目标不存在时，创建从 `ghostty-config` 到该目标的单一链接。重载 Ghostty 配置或打开新窗口后，确认主题、字体和 SSH shell integration 生效。

若 `MesloLGS NF` 未安装，报告字体缺失和可选替代方案，不修改系统字体或更改仓库配置。
