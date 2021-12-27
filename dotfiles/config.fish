function fish_greeting
    echo Hi(set_color yellow) $USER(set_color normal)@(set_color yellow)$hostname(set_color normal),\
    have a nice day! The time is (set_color yellow; date +%T;set_color normal)
    echo TMUX status is:
    tmux ls
end

set -x PIP_REQUIRE_VIRTUALENV true
