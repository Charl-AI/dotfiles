function fish_greeting
    echo Hi(set_color yellow) $USER(set_color normal)@(set_color yellow)$hostname(set_color normal),\
    have a nice day! The time is (set_color yellow; date +%T;set_color normal)
    echo TMUX status is:
    tmux ls
end

set -x PIP_REQUIRE_VIRTUALENV true

function fish_user_key_bindings
  fish_vi_key_bindings
end

# atuin allows for nice history search with ctrl-r
set -gx ATUIN_NOBIND "true"
atuin init fish | source

# bind to ctrl-r in normal and insert mode, add any other bindings you want here too
bind \cr _atuin_search
bind -M insert \cr _atuin_search
