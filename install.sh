#!/usr/bin/env bash

# Exit on first failure
set -e

# this should contain all statements that require root privileges
function install_packages {
	echo "Installing packages"

	which sudo || apt-get install -y sudo
	sudo apt-get update -y

	echo "Install everything"
	DEBIAN_FRONTEND=noninteractive sudo apt-get install -y \
		autoconf \
		automake \
		build-essential \
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
	rm nvim-linux64.deb
}

# this should not require root privileges
function link_dotfiles {
	echo "SymLink dotfiles"

	# neovim
	mkdir -p $HOME/.config/
	ln -sf $HOME/dotfiles/dotfiles/nvim $HOME/.config/nvim

	# tmux
	ln -sf $HOME/dotfiles/dotfiles/.tmux.conf $HOME/.tmux.conf

	# fish
	mkdir -p $HOME/.config/fish
	ln -sf $HOME/dotfiles/dotfiles/config.fish $HOME/.config/fish/config.fish

	# .gitconfig
	ln -sf $HOME/dotfiles/dotfiles/.gitconfig $HOME/.gitconfig

}


function main {
	# if no arguments are passed, install everything and link dotfiles
	if [ $# -eq 0 ]; then
		install_packages
		link_dotfiles
		return
	fi

	# if "-h" or "--help" is passed, print help
	if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
		echo "Usage: $0 [OPTION]"
		echo "Install dotfiles and packages"
		echo ""
		echo "Options:"
		echo "  -h, --help     Print this help message"
		echo "  -p, --packages Install packages"
		echo "  -d, --dotfiles Link dotfiles"
		return
	fi

	# if "-p" or "--packages" is passed, install packages
	if [ "$1" = "-p" ] || [ "$1" = "--packages" ]; then
		install_packages
	fi

	# if "-d" or "--dotfiles" is passed, link dotfiles
	if [ "$1" = "-d" ] || [ "$1" = "--dotfiles" ]; then
		link_dotfiles
	fi

}

main "$@"
