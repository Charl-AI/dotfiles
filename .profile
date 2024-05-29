# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists. Use this file to set environment variables and add items to PATH.

# add homebrew-installed packages to PATH
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

if [ -x "$(command -v pyenv)" ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
else
  echo "pyenv not found. Using system python."
fi

if [ -x "$(command -v rg)" ]; then
  export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
fi

if [ -x "$(command -v fzf)" ]; then
  export FZF_DEFAULT_OPTS='--cycle --layout=reverse --border --height=90% --preview-window=wrap --marker="*"'
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
  export PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
  # include .bashrc if it exists
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi
