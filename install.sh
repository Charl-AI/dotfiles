#!/usr/bin/env sh

# Exit on first failure
set -e

echo "Installing prerequisites"
which sudo || apt-get install -y sudo
sudo apt-get update -y
yes | sudo apt-get install software-properties-common
yes | sudo add-apt-repository ppa:neovim-ppa/stable
sudo add-apt-repository ppa:apt-fast/stable
sudo apt-get update -y

echo "Install everything"
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y \
	git \
	wget \
	curl \
	nano \
	neovim \
	tmux \
	fish

echo "SymLink dotfiles"

# inputrc
ln -sf $HOME/dotfiles/dotfiles/.inputrc $HOME/.inputrc

# nano
ln -sf $HOME/dotfiles/dotfiles/.nanorc $HOME/.nanorc

# neovim, need to run bootstrap script 2-3 times for some reason
mkdir -p $HOME/.config/nvim
ln -sf $HOME/dotfiles/dotfiles/init.lua $HOME/.config/nvim/init.lua
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

ln -sf $HOME/dotfiles/dotfiles/.tmux.conf $HOME/.tmux.conf

# fish
mkdir -p $HOME/.config/fish
ln -sf $HOME/dotfiles/dotfiles/config.fish $HOME/.config/fish/config.fish

