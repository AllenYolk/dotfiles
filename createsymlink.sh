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
nvim_items=(init.lua lazy-lock.json lua)

if [[ -L "$nvim_target" ]]; then
    if [[ "$(realpath "$nvim_target")" == "$(realpath "$nvim_source")" ]]; then
        unlink "$nvim_target"
    else
        print "Skipped $nvim_target because it points to another location."
        exit 0
    fi
fi

mkdir -p "$nvim_target"

for item in $nvim_items; do
    source_item="$nvim_source/$item"
    target_item="$nvim_target/$item"

    if [[ -L "$target_item" ]]; then
        if [[ "$(realpath "$target_item")" == "$(realpath "$source_item")" ]]; then
            continue
        fi
        print "Skipped $target_item because it points to another location."
    elif [[ -e "$target_item" ]]; then
        print "Skipped $target_item because it already exists."
    else
        ln -s "$source_item" "$target_item"
    fi
done
