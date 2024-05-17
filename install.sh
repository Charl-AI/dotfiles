#!/usr/bin/env bash

# Exit on first failure
set -e

# this should contain all statements that require root privileges
function install_packages {
	echo "Installing packages"

	which sudo || apt-get install -y sudo
	sudo apt-get update -y

	# TODO: Consider building from source or doing a user-install to avoid sudo
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
		fzf \
		tree \
		fish

	# gh cli
	type -p curl >/dev/null || sudo apt install curl -y
	curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg &&
		sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg &&
		echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null &&
		sudo apt update &&
		sudo apt install gh -y

	# nvim
	curl -LO https://github.com/neovim/neovim/releases/download/v0.10.0/nvim-linux64.tar.gz
	sudo rm -rf /opt/nvim
	sudo tar -C /opt -xzf nvim-linux64.tar.gz

	# lazygit
	cd /tmp/ &&
		LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') &&
		curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" &&
		tar xf lazygit.tar.gz lazygit &&
		sudo install lazygit /usr/local/bin

}

# this should not require root privileges
# TODO: switch to stow for nicer management of symlinks
function link_dotfiles {
	echo "SymLink dotfiles"

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
