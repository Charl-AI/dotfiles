# dotfiles

Dotfiles for my custom settings and a script for installing them.

The general idea is to use homebrew to manage most of my command-line tools. Running the `install.sh` script allows us to use the `.Brewfile` to declaratively build my dependencies. All old packages not specified in the brewfile will be cleaned up. This is my attempt at making a poor-man's nix; see [this blog](https://matthiasportzel.com/brewfile/) for the inspiration behind it.

Use the system package manager for installing GUI apps such as chrome, terminal emulators, nvidia stuff etc.

## Prerequisites (manual)

- Install [wezterm](https://wezfurlong.org/wezterm/)
- Install [homebrew/linuxbrew](https://docs.brew.sh/Homebrew-on-Linux) and its dependencies (`curl`, `build-essential`, etc.)
- Install [keyd](https://github.com/rvaiya/keyd), and add the following to `/etc/keyd/default.conf`:

```
[ids]

*

[main]

# Maps capslock to escape when pressed and control when held.
capslock = overload(control, esc)
```

## Installation

Install this repo in `$HOME`:

```bash
cd $HOME
git clone https://github.com/Charl-AI/dotfiles.git
```

Next, use the install script to set everything up.

```bash
cd $HOME/dotfiles
chmod +x ./install.sh
./install.sh
```

The install script does two things: it syncs your packages with the contents of `.Brewfile`, and it symlinks all dotfiles to the appropriate places. You can run either stage separately by passing the following arguments (see `./install.sh --help` also):

```bash
# Stage 1: sync packages with `.Brewfile`
./install.sh -p

# Stage 2: symlink dotfiles
./install.sh -d
```

NB: on some machines, you may not have `brew` available and may not be able to have it installed (work/organisation machines). In this case, simply manually install the packages through other means (binaries, apt, etc.). Then, just run `./install.sh -d` to symlink the dotfiles and avoid managing packages with `brew`.

## Updating

To update, simply pull the latest version of the repo and re-run the install script. It is not always necessary to perform the latter step, but the script is idempotent, so doing so won't create any problems.

## Developing

To test out the dotfiles in a sandboxed environment, you can use docker to build a container with:

`docker build -f .devcontainer/Dockerfile . -t dotfiles-test`

This container is simply an Ubuntu environment with a user called 'vscode'. Then you can run the container with:

`docker run -it dotfiles-test`

Running the container will install the dotfiles, then open an interactive tmux session in the container.

To test out the dotfiles with vscode devcontainers, run `Remote Containers: Rebuild and Reopen in Container` from the vscode command palette to create a container with the dotfiles installed. This requires Docker and the vscode remote development - containers extension. You will need to have set this repository and install script in settings, e.g. `{"dotfiles.repository": "Charl-AI", "remote.containers.dotfiles.repository": "Charl-AI/dotfiles",}`. NOTE: this will install the dotfiles latest version from GitHub, so un-pushed changes will not show up with this method (whereas they will with the above method).

## MacOS

Apple laptops are great, but for a while I found MacOS frustrating. These are my current settings to alleviate the pain:

- [Karabiner](https://karabiner-elements.pqrs.org/) is for keyboard remapping and my `karabiner.json` is saved in this repo. The general idea is to map caps to cmd and esc most of the time, but change it to ctrl and esc when in the terminal. This gives a pretty close experience to linux. Make sure to disable the default keymap for ctrl-space (input switching) in settings, as this clashes with my tmux prefix.

- [Alt-Tab](https://alt-tab-macos.netlify.app/) and [rectangle](https://rectangleapp.com/) are both pretty useful to improve window management on MacOS. In rectangle, I like to map cmd-{up,down,left,right} to snap windows a bit like the super key in gnome.

- [Shortcat](https://shortcat.app/) is nice for being mouseless. I tend to use cmd+/ as the trigger.
