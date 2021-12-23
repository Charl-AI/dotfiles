#!/usr/bin/env bash

# Exit on first failure
set -e

# Prerequisites
sudo apt update -y
which git || sudo apt install -y git
which curl || sudo apt install -y curl
which wget || sudo apt install -y wget

echo "Install nano"
which nano || sudo apt install -y nano
ln -sf $HOME/dotfiles/dotfiles/.nanorc $HOME/.nanorc

echo "Install tmux"
which tmux || sudo apt install -y tmux
ln -sf $HOME/dotfiles/dotfiles/.tmux.conf $HOME/.tmux.conf


echo "Installing fish"
which fish || sudo apt install -y fish
mkdir -p $HOME/.config/fish
ln -sf $HOME/dotfiles/dotfiles/config.fish $HOME/.config/fish/config.fish

echo "Installing starship prompt"
which starship || sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes
ln -sf $HOME/dotfiles/dotfiles/starship.toml $HOME/.config/starship.toml

echo "Installing Oh-My-Fish"
ls $HOME/.local/share/omf/ || fish -c "curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish"

# NOTE: Now use starship instead of robbyrussell, so commented out
# echo "Changing default theme"
# ls $HOME/.local/share/omf/themes/robbyrussell/ || fish -c "omf install robbyrussell"

echo "Installing z command"
ls $HOME/.local/share/omf/pkg/z/ || fish -c "omf install z"

# Comment out for now because it can cause installation to hang waiting for password
# echo "Setting fish as default shell"
# if [ $SHELL != $(which fish) ]; then chsh -s $(which fish); fi
