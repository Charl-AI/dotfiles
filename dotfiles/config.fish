function fish_greeting
    echo Hi(set_color yellow) $USER(set_color normal)@(set_color yellow)$hostname(set_color normal),\
    have a nice day! The time is (set_color yellow; date +%T;set_color normal)
    echo TMUX status is:
    tmux ls
end


function fish_user_key_bindings
  fish_vi_key_bindings
  fzf_key_bindings
end

set -x FZF_DEFAULT_OPTS '--cycle --layout=reverse --border --height=90% --preview-window=wrap --marker="*"'

# show directory tree in fzf preview, include hidden files, exclude .git
set FZF_ALT_C_OPTS "--preview 'tree -C -a -I '.git' {}'"


# (c)hancge (e)nvironment with conda
function ce
    conda activate (conda info --envs | fzf | awk '{print $1}')
end

# Use the first conda installation found in the following list
set -x CONDA_PATH /data/miniconda3/bin/conda /vol/biomedic3/cj1917/miniconda3/bin/conda $HOME/miniconda3/bin/conda

# use ripgreprc
set -x RIPGREP_CONFIG_PATH $HOME/.ripgreprc

function conda
    echo "Lazy loading conda upon first invocation..."
    functions --erase conda
    for conda_path in $CONDA_PATH
        if test -f $conda_path
            echo "Using Conda installation found in $conda_path"
            eval $conda_path "shell.fish" "hook" | source
            conda $argv
            return
        end
    end
    echo "No conda installation found in $CONDA_PATH"
end

# add personal bin to PATH if it exists
if test -d $HOME/bin
    set -x PATH $HOME/bin $PATH
end

if test -d $HOME/.local/bin
    set -x PATH $HOME/.local/bin $PATH
end

