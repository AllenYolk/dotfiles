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
