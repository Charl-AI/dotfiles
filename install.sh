#!/usr/bin/bash

# Exit on first failure
set -e

# Prerequisites
sudo apt update -y
which git || sudo apt install -y git
which curl || sudo apt install -y curl
which wget || sudo apt install -y wget

# Install fish
which fish || sudo apt install -y fish

# Make fish the default shell
if [ $SHELL != $(which fish) ]; then chsh -s $(which fish); fi

# install oh-my-fish
curl -L https://get.oh-my.fish | fish
omf update omf

# change default theme
omf install robbyrussell
omf theme robbyrussell

# install z command
omf install z

# install fish config
ln -sf $HOME/dotfiles/dotfiles/config.fish $HOME/.config/fish/config.fish

# Install tmux
which tmux || sudo apt install -y tmux

# Install my tmux conf
ln -sf $HOME/dotfiles/dotfiles/.tmux.conf $HOME/.tmux.conf
