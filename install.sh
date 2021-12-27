#!/usr/bin/env bash

# Exit on first failure
set -e

# Prerequisites
sudo apt update -y
which git || sudo apt install -y git
which curl || sudo apt install -y curl
which wget || sudo apt install -y wget

echo "Installing nano"
which nano || sudo apt install -y nano
ln -sf $HOME/dotfiles/dotfiles/.nanorc $HOME/.nanorc

echo "Installing tmux"
which tmux || sudo apt install -y tmux
ln -sf $HOME/dotfiles/dotfiles/.tmux.conf $HOME/.tmux.conf

echo "Installing fish"
which fish || sudo apt install -y fish
mkdir -p $HOME/.config/fish
ln -sf $HOME/dotfiles/dotfiles/config.fish $HOME/.config/fish/config.fish

echo "Installing Oh-My-Fish"
ls $HOME/.local/share/omf/ || fish -c "curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish"
ls $HOME/.local/share/omf/themes/robbyrussell/ || fish -c "omf install robbyrussell"

echo "Installing z command"
ls $HOME/.local/share/omf/pkg/z/ || fish -c "omf install z"
