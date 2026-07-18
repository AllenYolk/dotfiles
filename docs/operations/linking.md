# Linking Protocol and Inventory

This repository does not provide a bulk deployment script. An agent handles one configuration domain at a time and creates links only for absent targets. This preserves machine-local files, private credentials, and tool state.

## Preflight

From the repository root, run these read-only checks and report the result:

```bash
repo=$(git rev-parse --show-toplevel)
test -f "$repo/.zshrc"
test -d "$repo/nvim"
```

Before creating each planned link, run `test -e "$target" -o -L "$target"`. A successful result means the target is occupied and must not be changed. Use `readlink "$target"` only to report a symlink's destination.

## Creation Rules

After confirmation and only when a target is absent, create one explicit link, for example:

```bash
ln -s "$repo/.tmux.conf" "$HOME/.tmux.conf"
```

Do not use force options and do not combine domains in a command. Each target within a domain is independently confirmed, created, or skipped. A conflict stops only that target, not other conflict-free targets. See [Neovim](neovim.md) for its directory and per-item rules.

## Managed Inventory

| Domain | Source | Target |
| --- | --- | --- |
| Shell | `.aliases` | `~/.aliases` |
| Shell | `.p10k.zsh` | `~/.p10k.zsh` |
| Git | `.gitconfig` | `~/.gitconfig` |
| Git | `.gitcommitmessage` | `~/.gitcommitmessage` |
| tmux | `.tmux.conf` | `~/.tmux.conf` |
| Neovim | `nvim/init.lua` | `~/.config/nvim/init.lua` |
| Neovim | `nvim/lazy-lock.json` | `~/.config/nvim/lazy-lock.json` |
| Neovim | `nvim/lua` | `~/.config/nvim/lua` |

Ghostty has platform-specific targets; see [Ghostty](ghostty.md).

`.zshrc` is a repository source but not a deployable target. Higher-level safety rules prohibit an agent from modifying `~/.zshrc`; it may report its existence but must not create, replace, or link it.

## Conflicts and Rollback

When a target exists, stop work on that target. Report the source, target, and target type. Do not back up, move, delete, or replace it without separate, explicit authorization for that exact path.

To roll back a link created in the current task, first list the exact path and obtain confirmation. Remove only that one confirmed link. Never recursively delete a directory or alter a link unrelated to this repository.
