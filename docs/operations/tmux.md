# tmux Configuration

This domain manages `.tmux.conf`. Read the [Linking Protocol](linking.md) before deployment.

## Dependencies

| Level | Tool or service | Purpose | Verification |
| --- | --- | --- | --- |
| Required | tmux | Loads this configuration | `tmux -V` |
| Required | `xterm-256color` terminfo | Terminal type configured by this file | `infocmp xterm-256color` |
| Required | TPM | `.tmux.conf` unconditionally loads `~/.tmux/plugins/tpm/tpm`; without it plugin loading reports an error | `test -x ~/.tmux/plugins/tpm/tpm` |
| Conditional | Git and network access | Initial installation of TPM and its declared plugins | `git --version` |
| Conditional | `vim-tmux-navigator`, installed by TPM | Navigation between tmux and Neovim | TPM plugin directory exists |
| Platform-specific | OSC52-capable terminal | Remote-copy workflow for `set-clipboard on` | Manually copy in the target terminal |

On macOS, Homebrew can install tmux; on Linux, use the distribution package manager. When TPM is absent, explain that it downloads to `~/.tmux/plugins/tpm`, obtain confirmation, then install it from its official Git repository without overwriting an existing directory.

## Configuration

The configuration enables mouse support, vi-style pane navigation, 10,000 lines of history, `xterm-256color`, and OSC52-related `set-clipboard on`. It declares TPM and `vim-tmux-navigator`. Dracula status options are present, but its TPM plugin declaration is commented out, so it is not enabled automatically.

## Setup

After confirming that `tmux` is available and `~/.tmux.conf` is absent, create one link. TPM lives under `~/.tmux/plugins/tpm` as machine-local plugin state. If it is absent, report it and wait for confirmation; do not edit or replace the tmux configuration merely because plugins are missing.

## Verification

Load the configuration in a new tmux server:

```bash
tmux -L dotfiles-check -f "$HOME/.tmux.conf" start-server
tmux -L dotfiles-check show-options -s | grep 'set-clipboard'
tmux -L dotfiles-check kill-server
```

The final command closes only the verification server named `dotfiles-check`; never terminate an existing user tmux session.
