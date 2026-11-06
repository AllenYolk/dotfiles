# Dotfiles Operations Guide

This repository stores portable personal configuration. It is not an installation-script collection. Managed configuration includes:

| Domain | Repository source | Default target |
| --- | --- | --- |
| Shell | `.zshrc`, `.aliases`, `starship.toml` | `~/.zshrc`, `~/.aliases`, and `~/.config/starship.toml` when targets are absent |
| Git | `.gitconfig`, `.gitcommitmessage` | `~/.gitconfig`, `~/.gitcommitmessage` |
| tmux | `.tmux.conf` | `~/.tmux.conf` |
| Neovim | `nvim/init.lua`, `nvim/lua/`, `nvim/lazy-lock.json` | Corresponding entries under `~/.config/nvim/` |
| Ghostty | `ghostty-config` | See [Ghostty](docs/operations/ghostty.md) |

## Deployment Protocol

1. Read the relevant operation file before inspecting a source or target. Do not infer a target from its filename.
2. Handle one user-selected domain at a time, and handle every target in that domain independently. Report planned links and conflicts before modifying anything. A conflict for one target must not block other conflict-free targets.
3. Create links only for absent targets. Do not use `ln -f`, `ln -sf`, `rm`, `unlink`, `mv`, or overwrite operations to resolve a conflict.
4. If a target already exists, including as a file, directory, or symlink, stop work on that target. Report its type and `readlink` result, then wait for the user's decision.
5. Never read, copy, print, commit, or synchronize private environment files, API keys, tokens, SSH configuration, or other credentials. Machine-local state stays outside this repository.
6. Verify only the domain changed in the current task, then report created links, skipped items, commands, and verification results. On remote hosts, follow the root safety rules and `ENV.md` when present.
7. Treat the repository `.zshrc` as the shell source of truth. Create `~/.zshrc` as a symlink only when the target is absent; never overwrite or retarget an occupied target without explicit authorization. If it already points to this repository, edit the source and leave the link unchanged. Shell operations may also handle `.aliases` and `starship.toml` under the same target rules.

`createsymlink.sh` was removed because it deleted links across unrelated domains and must not be used for deployment.

## Operation Files

- [Linking Protocol and Inventory](docs/operations/linking.md): preflight checks, link commands, and rollback boundaries.
- [Shell and Prompt](docs/operations/shell.md): Native Zsh, Starship, aliases, and standalone extension dependencies.
- [Git](docs/operations/git.md): identity, commit template, editor, and proxy boundaries.
- [tmux](docs/operations/tmux.md): TPM, clipboard behavior, and verification.
- [Neovim](docs/operations/neovim.md): dependencies, granular links, plugin synchronization, and validation.
- [Ghostty](docs/operations/ghostty.md): platform targets and font requirements.

The user-facing introduction is [README.md](README.md). Daily Neovim usage is documented in [docs/neovim-user-guide.md](docs/neovim-user-guide.md).
