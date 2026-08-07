# dotfiles

Portable personal configuration for Linux and macOS: Zsh, Git, tmux, Neovim, and Ghostty. This repository contains configuration sources, not a one-command installer. Every machine can have existing files, private credentials, and local tool state, so deployment is evaluated one domain at a time.

## How to Use It

After cloning the repository, do not run a bulk symlink script; it has been removed. Choose the configuration domain you need, then ask an agent with terminal access to read [AGENTS.md](AGENTS.md). The agent will inspect targets, report conflicts, and wait for confirmation before creating any links.

For example:

```text
Deploy this dotfiles repository's Neovim configuration. First read AGENTS.md and docs/operations/neovim.md, then list the targets and conflicts. Do not modify anything until I confirm.
```

This workflow never automatically replaces existing files, retargets another symlink, or synchronizes credentials. Plugin directories, caches, private `.env` files, WakaTime settings, and machine-local environment state remain on the target machine.

## Configuration Entry Points

| Domain | Contents | Setup guide |
| --- | --- | --- |
| Shell | Native Zsh, Starship, and standalone extensions | [Shell and Prompt](docs/operations/shell.md) |
| Git | Identity, Neovim editor, and commit template | [Git](docs/operations/git.md) |
| tmux | Pane navigation, clipboard support, and TPM plugin declarations | [tmux](docs/operations/tmux.md) |
| Neovim | Python and Markdown development, terminal workflow, and AI completion | [Neovim setup](docs/operations/neovim.md) · [User guide](docs/neovim-user-guide.md) |
| Ghostty | Theme, font, and SSH shell integration | [Ghostty](docs/operations/ghostty.md) |

The managed source-to-target mapping is in [Linking Protocol and Inventory](docs/operations/linking.md).

## Notes

- `.gitconfig` contains a personal identity. Confirm it is appropriate before deploying it to another identity.
- Git proxy configuration is machine or session state and must not be committed here, otherwise machines without the same network setup may lose GitHub access.
- Neovim AI completion uses MiniMax-M3 through the MiniMax China OpenAI-compatible endpoint. It reads machine-local credentials and sends editing context to MiniMax; credentials never belong in this repository.
