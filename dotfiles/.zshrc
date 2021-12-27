# Add confirmation message to rm.
alias rm="rm -i"

source $HOME/dotfiles/dotfiles/zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/dotfiles/dotfiles/zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
eval "$(starship init zsh)"

# Welcome message
echo Hello $USER. Have a nice day! Tmux status is:
tmux ls
