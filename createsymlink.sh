#! /usr/bin/env zsh

dotfile_list=(
    .aliases 
    .gitconfig 
    .p10k.zsh 
    .tmux.conf 
    .vimrc
    .zshrc
)

for df in ${dotfile_list[*]}; do
    if [[ -f ~/${df} ]]; then
        rm -f ~/${df}
    fi
    ln -s $(pwd)/${df} ~/${df}
done
