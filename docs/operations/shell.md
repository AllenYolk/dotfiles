# Shell and Prompt

This domain covers Zsh startup files, aliases, and the Powerlevel10k prompt. Read the [Linking Protocol](linking.md) before deployment.

## Managed Files

| Source | Target | Purpose |
| --- | --- | --- |
| `.zshrc` | Not deployed | Oh My Zsh, plugins, aliases, and local environment entry point |
| `.aliases` | `~/.aliases` | Common Git, directory, GPU, and Conda aliases |
| `.p10k.zsh` | `~/.p10k.zsh` | Powerlevel10k prompt appearance |

## Dependencies

`.zshrc` depends on the following components:

| Level | Tool or service | Purpose |
| --- | --- | --- |
| Required | Zsh and Oh My Zsh | Starts the shell and loads themes and plugins |
| Required | Powerlevel10k | Implements the `.p10k.zsh` theme |
| Required | `$HOME/.local/bin/env` | Machine-local environment entry point; it is outside this repository and its contents must not be read or created by an agent |
| Required | Oh My Zsh custom plugins: `zsh-autosuggestions`, `zsh-syntax-highlighting`, `git-open`, `zsh-vi-mode` | Explicitly enabled by `.zshrc` |
| Conditional | `autojump` | Command used by Oh My Zsh's `autojump` plugin |
| Alias-only | `git`, `fzf`, `nvim` | Git aliases, `lf`, and `vrc` |
| Alias-only | `tldr`, `watch`, `nvidia-smi`, `nvitop`, `conda`, `citation_refiner` | Needed only when the matching alias or function is used; `tldr` affects startup only on host `bogon` |

On macOS, Homebrew can install `zsh`, `autojump`, `fzf`, and Git. Install `nvitop` with `uv tool install nvitop`. Oh My Zsh, Powerlevel10k, and custom plugins belong in the user's existing Oh My Zsh directory; confirm their installation source and never execute a remote `curl | sh` script. `citation_refiner` is a user-provided command with no installation source in this repository.

Higher-level safety rules prohibit an agent from modifying `~/.zshrc`. The agent must report this limitation and must not bypass it by editing, linking, replacing, or generating another startup file.

Powerlevel10k must be installed in the Oh My Zsh custom theme directory. Ghostty defaults to a Nerd Font; see [Ghostty](ghostty.md) for font requirements.

## Setup and Verification

After confirmation and only when the individual target is absent, an agent may create links for `.aliases` and `.p10k.zsh`. It must skip `.zshrc`. Verify the aliases file itself:

```bash
zsh -fc 'source "$HOME/.aliases"; alias glog'
```

Do not run non-interactive commands that modify environment state. The user maintains whether the existing `.zshrc` loads these files and any machine-specific Conda, NVM, or uv initialization.
