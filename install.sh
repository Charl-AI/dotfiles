#!/usr/bin/env bash

# Exit on first failure
set -e

function install_packages {
  echo "Installing packages"

  brew update &&
    brew bundle install --cleanup --file=$HOME/dotfiles/.Brewfile --no-lock &&
    brew upgrade

}

function link_dotfiles {
  echo "Symlinking dotfiles"
  stow .

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
