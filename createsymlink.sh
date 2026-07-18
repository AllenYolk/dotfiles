#! /usr/bin/env zsh

dotfile_list=(
    .aliases
    .gitcommitmessage
    .gitconfig
    .p10k.zsh
    .tmux.conf
    .vimrc
    .zshrc
)

for df in ${dotfile_list[*]}; do
    if [[ -L ~/${df} ]]; then
        rm -f ~/${df}
    fi
    ln -s $(pwd)/${df} ~/${df}
done

nvim_source="$(pwd)/nvim"
nvim_target="$HOME/.config/nvim"

if [[ -L "$nvim_target" ]]; then
    rm -f "$nvim_target"
fi

if [[ ! -e "$nvim_target" ]]; then
    mkdir -p "$HOME/.config"
    ln -s "$nvim_source" "$nvim_target"
else
    print "Skipped $nvim_target because it already exists and is not a symlink."
fi
