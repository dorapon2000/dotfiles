#!/usr/bin/env bash

# For macOS

set -ue

readonly SCRIPT_DIR=$(cd $(dirname $0) && pwd)
readonly ROOT_DIR="$SCRIPT_DIR/.."
readonly BACKUP=backup/$(date "+%Y%m%d")

# Back up a file
#
# Args:
#   File to be backed up
backup() {
    if [[ -e "$1" ]]; then
        if [[ ! -e "$BACKUP" ]]; then
            mkdir -p $BACKUP
        fi
        mv "$1" $BACKUP
    fi
}

# bash
#
# - Update .bashrc
install_bash() {
    backup ~/.bashrc
    cp $ROOT_DIR/.bashrc ~
}

# zsh
#
# - Install oh-my-zsh (https://github.com/ohmyzsh/ohmyzsh)
# - Update .zshrc
install_zsh() {
    if [ -e "~/.oh-my-zsh" ]; then
        exit
    fi
    
    backup ~/.zshrc
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    cat $ROOT_DIR/.zshrc >> ~/.zshrc
}

# fish
#
# - Install fish
# - Set fish as default shell
# - Install fisherman
# - Install theme
# - Update config.fish
install_fish() {
    if type fish >/dev/null 2>&1; then
        exit
    fi
    
    brew install fish
    echo $(which fish) | sudo tee -a /etc/shells
    chsh -s $(which fish)
    curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisherman
    fish -c "fisher git_util"
    fish -c "fisher rafaelrinaldi/pure"
    cat $ROOT_DIR/config.fish >> ~/.config/fish/config.fish
}

# gdb
#
# Copy .gdbinit to $HOME
install_gdb() {
    backup ~/.gdbinit
    cp $ROOT_DIR/.gdbinit ~
}

# git
#
# Copy .gitconfig_share to $HOME
install_git() {
    backup ~/.gitconfig_share
    cp $ROOT_DIR/.gitconfig_share ~
    git config --global include.path "$HOME/.gitconfig_share"
}

# emacs
#
# https://dorapon2000.hatenablog.com/entry/2016/07/25/21
install_emacs() {
    if ! type emacs >/dev/null 2>&1; then
        brew install emacs
    fi
    
    backup ~/.emacs.d
    backup ~/.emacsrc
    cp -r $ROOT_DIR/.emacs.d ~
    emacs --script ~/.emacs.d/setup.el
    emacs --script ~/.emacs.d/byte-compile.el
}

# vscode
install_vscode() {
    local VSCODE_SETTING_DIR=~/Library/Application\ Support/Code/User
    backup "$VSCODE_SETTING_DIR/settings.json"
    backup "$VSCODE_SETTING_DIR/keybindings.json"
    cp "$ROOT_DIR/settings.json" "${VSCODE_SETTING_DIR}/settings.json"
    cp "$ROOT_DIR/keybindings.json" "${VSCODE_SETTING_DIR}/keybindings.json"
}

main() {
    # install_bash
    # install_zsh
    install_fish
    # install_gdb
    # install_git
    install_emacs
    # install_vscode
}

main "$@"
