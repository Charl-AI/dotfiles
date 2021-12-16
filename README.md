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

Next, use the install script to set everything up:
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

Run `Remote Containers: Rebuild and Reopen in Container` from the vscode command palette to create a container with the dotfiles installed.
This requires Docker and the vscode remote development - containers extension. If the dotfiles do not automatically install, it might be
because you do not have them installed on your local system. In that case, you can point vscode to the remote dotfiles repository and install script in settings

## Additional notes for Ubuntu customisation:

Some modifications I like to change when using a fresh Ubuntu install. The `install.sh` script does not make these modification because it's set up to be as minimal as possible for use in development containers; it's generally best to make these adjustments manually is necessary.
```bash
# enable minimise on click
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'
```

Also set up super + I keyboard shortcut for settings and super + E shortcut for explorer (might have to do this manually by setting it to run ```nautilus```)

You also might want to disable smooth scrolling in chrome if it seems to scroll painfully slowly:
chrome://flags/#smooth-scrolling
