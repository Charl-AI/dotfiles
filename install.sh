#!/usr/bin/env bash

# Exit on first failure
set -e

# Prerequisites
sudo apt update -y
which git || sudo apt install -y git
which curl || sudo apt install -y curl

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
