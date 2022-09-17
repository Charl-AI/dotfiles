FROM ubuntu:latest as devcontainer

# Unminimize docker ubuntu to better reflect real use case
RUN yes | unminimize

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# [Optional] Set the default user. Omit if you want to keep the default as root.
USER $USERNAME

# commands below don't run when --target is set to "devcontainer"
FROM devcontainer
ARG USERNAME=vscode
WORKDIR /home/$USERNAME/dotfiles

COPY . .
RUN ./install.sh
CMD tmux
