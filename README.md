# dotfiles

Dotfiles for my custom settings and an install script for installing them. Not much special going on here,
one nice feature is that a vscode devcontainer is included. This allows us to use a container as a sandbox for
trying out changes. One nice feature of devcontainers is that they automatically look for dotfiles repositories
and run the `install.sh` file, so building the container allows us to test these configs.

## Installation

Install this repo in `$HOME`. It is easiest to do this with the GitHub CLI:
```bash
cd $HOME
gh repo clone Charl-AI/dotfiles
```
You can also perform `git clone git@github.com:Charl-AI/dotfiles.git $HOME/dotfiles` if you are not using the GitHub CLI.

Next, use the install script to set everything up. The script requires root privileges, so run as ksu on organisation machines where sudo is probably disabled:
```bash
cd $HOME/dotfiles
# give permissions for the script
chmod +x ./install.sh
./install.sh
```
Note: this script will not work properly if the repository was not created in `$HOME`, as specified above.

## Updating dotfiles

To update, pull the latest version of the repo and re-run the install script. It is not always necessary to perform the latter step, but the script is idempotent, so doing so won't create any problems.

## Developing

To test out the dotfiles in a sandboxed environment, you can use docker to build a container with:

```docker build -f .devcontainer/Dockerfile . -t dotfiles-test```

This container is simply an Ubuntu environment with a user called 'vscode'. Then you can run the container with:

```docker run -it dotfiles-test```

Running the container will install the dotfiles, then open an interactive tmux session in the container.

To test out the dotfiles with vscode devcontainers, run `Remote Containers: Rebuild and Reopen in Container` from the vscode command palette to create a container with the dotfiles installed. This requires Docker and the vscode remote development - containers extension. You will need to have set this repository and install script in settings, e.g. `{"dotfiles.repository": "Charl-AI", "remote.containers.dotfiles.repository": "Charl-AI/dotfiles",}`. NOTE: this will install the dotfiles latest version from GitHub, so un-pushed changes will not show up with this method (whereas they will with the above method).

## Additional notes for manual customisation:

> This repo contains is for automatically installing dotfiles and CLI tools, it is designed to be minimal and used in containers. When setting up a new machine, these notes are for the extra steps I perform manually (mostly related to GUI shortcuts, terminal emulator etc.).

### Ubuntu shortcuts

Some modifications I like to change when using a fresh Ubuntu install. The `install.sh` script does not make these modification because it's set up to be as minimal as possible for use in development containers; it's generally best to make these adjustments manually if necessary.
```bash
# enable minimise on click for Ubuntu (Gnome)
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'
```
Also set up super + I keyboard shortcut for settings and super + E shortcut for explorer (might have to do this manually by setting it to run ```nautilus```)

### Terminal emulator + fonts

I'm not picky about terminal emulators, so stick with whatever is installed and configure it through the GUI. (Sadly) Neovim plugins often need nerd fonts installed to work properly.

Two good ones are Cascadia Code and JetBrains Mono:
```bash
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/JetBrainsMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/CascadiaCode.zip
```

On windows, simply move the zip file from WSL to the windows partition, then extract with the GUI. Install by opening the .ttf file and clicking install. On linux, do the following:
```
mkdir -p ~/.fonts
mv JetBrainsMono.zip ~/.fonts/
cd ~/.fonts
unzip JetBrainsMono.zip
fc-cache fv
```

After installing the font, remember to configure the terminal emulator to use it.
