#!/usr/bin/env bash

# Exit on first failure
set -e

# this should contain all statements that require root privileges
function install_packages {
	echo "Installing packages"

	brew update &&\
	brew bundle install --cleanup --file=~/.Brewfile --no-lock &&\
	brew upgrade

}

# this should not require root privileges
# TODO: switch to stow for nicer management of symlinks
function link_dotfiles {
	echo "SymLinking dotfiles"

	# Brewfile
	ln -sf "$HOME/dotfiles/dotfiles/.Brewfile" "$HOME/.Brewfile"

	# .profile
	ln -sf "$HOME/dotfiles/dotfiles/.profile" "$HOME/.profile"

	# neovim
	mkdir -p "$HOME/.config/"
	ln -sf "$HOME/dotfiles/dotfiles/nvim" "$HOME/.config/nvim"

	# helix
	mkdir -p "$HOME/.config/helix"
	ln -sf "$HOME/dotfiles/dotfiles/helix/config.toml" "$HOME/.config/helix/config.toml"

	# tmux
	ln -sf "$HOME/dotfiles/dotfiles/.tmux.conf" "$HOME/.tmux.conf"

	# fish
	mkdir -p "$HOME/.config/fish"
	ln -sf "$HOME/dotfiles/dotfiles/config.fish" "$HOME/.config/fish/config.fish"

	# .gitconfig
	ln -sf "$HOME/dotfiles/dotfiles/.gitconfig" "$HOME/.gitconfig"

	# ripgrep
	ln -sf "$HOME/dotfiles/dotfiles/.ripgreprc" "$HOME/.ripgreprc"

	# wezterm
	ln -sf "$HOME/dotfiles/dotfiles/.wezterm.lua" "$HOME/.wezterm.lua"

	# personal scripts
	mkdir -p "$HOME/bin"
	ln -sf "$HOME/dotfiles/bin/"* "$HOME/bin/"

	for file in "bin/"*; do
		if [ -f "$file" ]; then
			chmod +x "$file"
		fi
	done

}

function main {
	# if no arguments are passed, install everything and link dotfiles
	if [ $# -eq 0 ]; then
		link_dotfiles
		install_packages
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
