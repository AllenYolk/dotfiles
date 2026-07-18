# dotfiles

My dotfiles for Linux / macOS.

## Neovim

`nvim/` is the portable source for the Neovim configuration. Run
`./createsymlink.sh` from the repository root to link its managed entries to
`~/.config/nvim`. The directory itself remains local, so machine-specific files
such as `~/.config/nvim/.env` stay outside the repository.

The configuration targets Python, Markdown, terminal workflows, WakaTime, and
Minuet with OpenCode Go. See [docs/neovim-user-guide.md](docs/neovim-user-guide.md) for
dependencies, deployment, keymaps, and the agent deployment prompt.

## Notice

* Sometimes `.gitcofig` will contain `http.proxy` and `https.proxy` due to pigcha proxy running in the background. Make sure that these two settings do not exist in `.gitconfig`, or we cannot connect to github on a machine without VPN.
