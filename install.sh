#!/usr/bin/env bash

# Exit on first failure
set -e

# Prerequisites
sudo apt update -y
which git || sudo apt install -y git
which curl || sudo apt install -y curl
which wget || sudo apt install -y wget

echo "Installing nano"
which nano || sudo apt install -y nano
ln -sf $HOME/dotfiles/dotfiles/.nanorc $HOME/.nanorc

echo "Installing tmux"
which tmux || sudo apt install -y tmux
ln -sf $HOME/dotfiles/dotfiles/.tmux.conf $HOME/.tmux.conf

echo "Installing zsh"
command -v zsh || sudo apt install -y zsh

echo "Installing oh-my-zsh"
ls "$HOME/.oh-my-zsh" || echo "y" | sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
ls "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" || git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
ls "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ||  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
ln -sf "$HOME/dotfiles/dotfiles/.zshrc" "$HOME/.zshrc"
