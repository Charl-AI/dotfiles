function fish_greeting
    echo Hi(set_color yellow) $USER(set_color normal)@(set_color yellow)$hostname(set_color normal),\
    have a nice day! The time is (set_color yellow; date +%T;set_color normal)
    echo TMUX status is:
    tmux ls
end

set -x PIP_REQUIRE_VIRTUALENV true

function fish_user_key_bindings
  fish_vi_key_bindings
  fzf_key_bindings
end

# show directory tree in fzf preview, include hidden files, exclude .git
set FZF_ALT_C_OPTS "--preview 'tree -C -a -I '.git' {}'"

# add personal bin to PATH if it exists
if test -d $HOME/bin
    set -x PATH $HOME/bin $PATH
end

if test -d $HOME/.local/bin
    set -x PATH $HOME/.local/bin $PATH
end

