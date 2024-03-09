#!/bin/bash

# Define output colors
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to display messages
echo_progress() {
    echo -e "${GREEN}$1${NC}"
}

echo_progress "Installing Locale..."
# Locale to be set
locale="fr_FR.UTF-8"

# Uncomment the desired locale in /etc/locale.gen and generate it
sed -i "/$locale/s/^#//g" /etc/locale.gen
locale-gen fr_FR.UTF-8
update-locale
echo_progress "locale installed."

# Installing zsh
echo_progress "Installing zsh"
apt-get install zsh -y
chsh -s /usr/bin/zsh
echo_progress "zsh installed & set"

# Cloning GIT config
echo_progress "Cloning dotfiles from git"
yadm clone https://github.com/oliroche-git/dotfiles.git
echo_progress "dotfiles cloned."

echo_progress "Done"
