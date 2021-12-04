FROM ubuntu:latest

# Set build arguments
ARG USERNAME=d_user
ARG PASSWORD=password

# Unminimize docker ubuntu to better reflect real use case
RUN yes | unminimize

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Set up non-root user
RUN useradd $USERNAME -m

# Add user to sudoers group
RUN usermod -aG sudo $USERNAME

# Set password of user to "password"
RUN yes $PASSWORD | passwd $USERNAME

# Switch user
USER $USERNAME

# Switch to d_user's home directory
WORKDIR /home/$USERNAME

# Copy contents
COPY . /home/$USERNAME/dotfiles

CMD cd dotfiles && \
    ./install.sh && \
    cd ~ && \
    fish
