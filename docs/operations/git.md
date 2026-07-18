# Git Configuration

This domain contains `.gitconfig` and `.gitcommitmessage`. Read the [Linking Protocol](linking.md) before deployment.

## Dependencies

`git` is required to use this domain. The repository configures `core.editor=nvim`, so Neovim is also required to edit commit messages. On macOS, Homebrew can install `git` and `neovim`; on Linux, use the distribution package manager.

```bash
git --version
nvim --version
```

## Setup

`.gitconfig` currently contains a personal name, email address, Neovim editor, and commit template path. Before linking it, report its identity alongside `git config --global --get user.email` on the target machine. If the identity differs or the target exists, skip only `.gitconfig`; never merge or overwrite it.

Check and confirm `.gitconfig` and `.gitcommitmessage` independently. An absent target may be linked even when the other target conflicts. The template is effective only when the target Git configuration points `commit.template` at `~/.gitcommitmessage`; report that dependency without overwriting or blocking another conflict-free target.

## Verification

```bash
git config --global --get user.name
git config --global --get user.email
git config --global --get commit.template
```

The output should show the expected identity and `~/.gitcommitmessage`. Do not create a commit merely to verify the configuration.

## Proxy Boundary

Do not write temporary VPN or proxy settings into the repository's `.gitconfig`. Prefer session state or a machine-local Git setting confirmed by the user, then ensure it cannot disrupt machines without the same VPN configuration.
