#!/usr/bin/env sh

# Exit on first failure
set -e

echo "Installing prerequisites"
which sudo || apt-get install -y sudo
sudo apt-get update -y

echo "Install everything"
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y \
	autoconf \
        automake \
        cmake \
        coreutils \
        curl \
        git \
        xclip \
        libtool \
        pkgconf \
        unzip \
	wget \
	tmux \
	ripgrep \
	fish

wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.deb
sudo apt install ./nvim-linux64.deb

echo "SymLink dotfiles"

# neovim
mkdir -p $HOME/.config/nvim
ln -sf $HOME/dotfiles/dotfiles/init.lua $HOME/.config/nvim/init.lua

# tmux
ln -sf $HOME/dotfiles/dotfiles/.tmux.conf $HOME/.tmux.conf

# fish
mkdir -p $HOME/.config/fish
ln -sf $HOME/dotfiles/dotfiles/config.fish $HOME/.config/fish/config.fish
