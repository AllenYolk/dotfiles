# Command history.
HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000
setopt extended_history hist_expire_dups_first hist_ignore_dups hist_ignore_space hist_verify share_history
alias history='fc -li 1'

# Load optional machine-local environment settings.
[[ -r "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"

# Find Homebrew on Apple Silicon or Intel Macs.
brew_prefix="${HOMEBREW_PREFIX:-}"
if [[ -z "$brew_prefix" && -x /opt/homebrew/bin/brew ]]; then
    brew_prefix=/opt/homebrew
elif [[ -z "$brew_prefix" && -x /usr/local/bin/brew ]]; then
    brew_prefix=/usr/local
fi

# Find the installed Zsh extensions.
zsh_share_dir="${XDG_DATA_HOME:-$HOME/.local/share}/zsh"
if [[ -n "$brew_prefix" ]]; then
    export PATH="$brew_prefix/bin:$PATH"
    fpath=("$brew_prefix/share/zsh/site-functions" $fpath)
    zsh_share_dir="$brew_prefix/share"
    [[ -r "$brew_prefix/etc/profile.d/autojump.sh" ]] && source "$brew_prefix/etc/profile.d/autojump.sh"
fi

# Native completion.
autoload -Uz compinit
compinit

# Personal aliases and functions.
[[ -r "$HOME/.aliases" ]] && source "$HOME/.aliases"

# Interactive extensions. Syntax highlighting must be loaded last.
source "$zsh_share_dir/zsh-autosuggestions/zsh-autosuggestions.zsh"
eval "$(starship init zsh)"
source "$zsh_share_dir/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
