# Add confirmation message to rm.
alias rm="rm -i"

# use antigen to manage zsh plugins
source $HOME/dotfiles/dotfiles/antigen.zsh
antigen bundle z
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen apply

eval "$(starship init zsh)"

# Welcome message
echo Hello $USER. Have a nice day! Tmux status is:
tmux ls
