#!/usr/bin/bash

set -e

echo "Install tmux"
which tmux
ln -sf $HOME/dotfiles/dotfiles/.tmux.conf $HOME/.tmux.conf


echo "Installing fish"
which fish
mkdir -p $HOME/.config/fish
ln -sf $HOME/dotfiles/dotfiles/config.fish $HOME/.config/fish/config.fish

echo "Installing starship prompt"
which starship ||  yes y | sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes
ln -sf $HOME/dotfiles/dotfiles/starship.toml $HOME/.config/starship.toml

echo "Installing Oh-My-Fish"
ls $HOME/.local/share/omf/ || fish -c "curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish"

# NOTE: Now use starship instead of robbyrussell, so commented out
# echo "Changing default theme"
# ls $HOME/.local/share/omf/themes/robbyrussell/ || fish -c "omf install robbyrussell"

echo "Installing z command"
ls $HOME/.local/share/omf/pkg/z/ || fish -c "omf install z"
