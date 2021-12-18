function fish_greeting
    echo Hello $USER, have a nice day!
    echo The time is (set_color yellow; date +%T; set_color normal) and this machine is called $hostname
end

starship init fish | source
