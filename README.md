# dotfiles

Dotfiles for my custom settings and an install script for installing them. I am also shamelessly copying the Docker idea from: https://github.com/jwblangley/dotfiles for developing this repo.

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

(from https://github.com/jwblangley/dotfiles)

Modify the relevant file within the repository and commit the changes. For more complicated changes, modifying the setup script may be required. To promote development without risk of damaging your personal setup, a `Dockerfile` is included for a sandbox environment. This Dockerfile is designed to replicate the process of running the installation script for the first time. For example, unlike many docker images, the default user is non-root and is password-protected. Furthermore, the installation script is not fully automated since passwords and confirmations are required and the installation script's progress is not cached. The Dockerfile replicates this experience. The default user within the container is `d_user` and the default password is `password`. These can be changed with docker build args.

To build the docker image:

```bash
docker build [--build-arg USERNAME=<username>] [--build-arg PASSWORD=<password>] . -t dotfiles
```
To run the install script within the docker container and test the resulting setup:

```bash
docker run -it dotfiles
```

## Additional notes for Ubuntu customisation:

Some modifications I like to change when using a fresh Ubuntu install. The `install.sh` script does not make these modification because it's set up to be as minimal as possible for use in development containers; it's generally best to make these adjustments manually is necessary.
```bash
# enable minimise on click
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'
```

Also set up super + I keyboard shortcut for settings and super + E shortcut for explorer (might have to do this manually by setting it to run ```nautilus```)

You also might want to disable smooth scrolling in chrome if it seems to scroll painfully slowly:
chrome://flags/#smooth-scrolling
