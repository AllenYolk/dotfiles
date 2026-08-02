# Shell and Prompt

This domain covers the native Zsh startup file, aliases, Starship, and independently installed Zsh extensions. Read the [Linking Protocol](linking.md) before deployment.

## Managed Files

| Source | Target | Purpose |
| --- | --- | --- |
| `.zshrc` | `~/.zshrc` | Native Zsh options, history, completion, extensions, aliases, and Starship entry point |
| `.aliases` | `~/.aliases` | Common Git, directory, GPU, and Conda aliases |
| `starship.toml` | `~/.config/starship.toml` | Minimal Starship prompt appearance |

The repository `.zshrc` is the source of truth. On a new machine, deploy it as a symlink only when `~/.zshrc` is absent. If `~/.zshrc` already points to this repository, modify the source file and do not replace the symlink.

## Dependencies

The repository `.zshrc` expects:

| Level | Tool or service | Purpose |
| --- | --- | --- |
| Required | Zsh | Shell runtime and native completion/keymap support |
| Required | Starship | Prompt initialization and rendering |
| Required | `zsh-autosuggestions` | History/completion suggestions |
| Required | `zsh-syntax-highlighting` | Command-line syntax highlighting |
| Optional | `autojump` | Directory navigation through `j` |
| Optional | `$HOME/.local/bin/env` | Machine-local Conda, NVM, uv, PATH, or other environment initialization; the file stays outside this repository |
| Alias-only | `git`, `fzf`, `nvim` | Git aliases, `lf`, and `vrc` |
| Alias-only | `tldr`, `watch`, `nvidia-smi`, `nvitop`, `conda`, `citation_refiner` | Needed only when the matching alias or function is used |

On macOS, install the required external components with Homebrew:

```bash
brew install starship zsh-autosuggestions zsh-syntax-highlighting autojump
```

The configuration discovers the Homebrew prefix, so it supports both `/opt/homebrew` and `/usr/local` without hard-coded architecture-specific paths. Non-Homebrew machines should place the two Zsh extension directories below `${XDG_DATA_HOME:-$HOME/.local/share}/zsh` or adapt the source paths explicitly.

Do not install a plugin manager. Oh My Zsh, Powerlevel10k, `git-open`, `web-search`, `extract`, `colored-man-pages`, and the Oh My Zsh `aliases` plugin are no longer runtime dependencies.

Ghostty defaults to a Nerd Font; see [Ghostty](ghostty.md) if prompt glyphs do not render correctly.

## Setup and Verification

Before changing a target, inspect its type and symlink destination. The agent may create `~/.zshrc` and `~/.config/starship.toml` links only when those targets are absent and the user has confirmed the links.

The agent may create a link for `.aliases` only when `~/.aliases` is absent. It must skip an existing file, directory, or symlink. An existing `~/.zshrc` must likewise be preserved unless it is already the repository link or the user has explicitly authorized changing that exact target.

Static checks for the repository sources:

```bash
zsh -n .zshrc
zsh -n .aliases
```

After the repository source is linked as `~/.zshrc`, verify in a new interactive shell:

```bash
whence -w compinit starship autojump
alias glog
bindkey -M viins
```

Also verify Tab completion, autosuggestions, syntax highlighting, `j` when autojump is retained, Starship in Git and non-Git directories, and the machine-local environment entry point when present.

Do not run non-interactive commands that modify environment state. Do not read, copy, or create `$HOME/.local/bin/env`.
