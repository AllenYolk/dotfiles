# Git 配置

本领域由 `.gitconfig` 和 `.gitcommitmessage` 组成。部署前先读 [链接协议](linking.md)。

## 设置方式

`.gitconfig` 当前包含用户姓名、邮箱、默认编辑器和提交模板路径。agent 在链接前必须将其中的身份与目标机器现有 `git config --global --get user.email` 的结果报告给用户；身份不一致或目标已存在时停止，不得合并或覆盖。

若用户确认来源身份适用于目标机器，且 `~/.gitconfig` 与 `~/.gitcommitmessage` 都不存在，可分别创建链接。提交模板依赖 `.gitconfig` 内的 `~/.gitcommitmessage` 路径，因此应同时部署或两项都不部署。

## 验证

```bash
git config --global --get user.name
git config --global --get user.email
git config --global --get commit.template
```

输出应指向预期身份和 `~/.gitcommitmessage`。不运行会创建提交的命令进行验证。

## 代理边界

不要把临时 VPN/代理写入仓库的 `.gitconfig`。需要代理时，优先使用当前会话环境或经用户确认的机器本地 Git 配置；完成后确认不会影响其他无 VPN 的机器。
