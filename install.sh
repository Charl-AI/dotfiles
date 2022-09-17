#!/usr/bin/env sh

# Exit on first failure
set -e

# Prerequisites
which sudo || apt-get install -y sudo
yes | sudo apt-get install software-properties-common
yes | sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get update -y
which git || sudo apt install -y git
which curl || sudo apt install -y curl
which wget || sudo apt install -y wget

echo "Installing nano"
which nano || sudo apt install -y nano
ln -sf $HOME/dotfiles/dotfiles/.nanorc $HOME/.nanorc

echo "Installing neovim"
sudo apt install -y neovim
mkdir -p $HOME/.config/nvim
ln -sf $HOME/dotfiles/dotfiles/init.lua $HOME/.config/nvim/init.lua
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

echo "Installing tmux"
which tmux || sudo apt install -y tmux
ln -sf $HOME/dotfiles/dotfiles/.tmux.conf $HOME/.tmux.conf

echo "Installing fish"
which fish || sudo apt install -y fish
mkdir -p $HOME/.config/fish
ln -sf $HOME/dotfiles/dotfiles/config.fish $HOME/.config/fish/config.fish

# need to run this again to set up nvim properly for some reason
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
