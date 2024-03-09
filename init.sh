#!/bin/bash

# Define output colors
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to display messages
echo_progress() {
    echo -e "${GREEN}$1${NC}"
}

# Update and Upgrade
echo_progress "Updating package list..."
apt-get update -y
apt-get upgrade -y
echo_progress "System updated."


echo_progress "Installing Locale..."
# Locale to be set
locale="fr_FR.UTF-8"

# Uncomment the desired locale in /etc/locale.gen and generate it
sed -i "/$locale/s/^#//g" /etc/locale.gen
locale-gen fr_FR.UTF-8
update-locale
echo_progress "locale installed."

# Install Vim
echo_progress "Installing Vim..."
apt-get install vim -y
echo_progress "Vim installed."

# Install curl
echo_progress "Installing curl..."
apt-get install curl -yy
echo_progress "curl installed."

# Install starship
echo_progress "Installing starship..."
curl -sS https://starship.rs/install.sh | sh
echo_progress "starship installed."

# Install eza
echo_progress "Installing eza..."
apt update
apt install -y gpg

mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
apt update
apt install -y eza
echo_progress "eza installed."

# Install yadm
echo_progress "Installing yadm..."
apt-get install yadm -y
echo_progress "yadm installed."

# Install neofetch
echo_progress "Installing neofetch..."
apt-get install neofetch -y
echo_progress "neofetch installed."

# Install Node.js (using NVM for better version management)
echo_progress "Installing Node.js..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install node
echo_progress "Node.js installed."

# Install Python3 and pip
echo_progress "Installing Python3 and pip..."
apt-get install python3-pip -y
echo_progress "Python3 and pip installed."

echo_progress "All specified tools have been installed successfully."


# Ask for QEMU installation
echo -n "Do you want to install QEMU agent? (y/n)"
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo_progress "Installing QEMU agent..."
    apt-get install qemu-guest-agent -f
    systemctl start qemu-guest-agent
    systemctl enable qemu-guest-agent
    echo_progress "Docker QEMU agent installed."
else
    echo_progress "Skipping QEMU agent installation."
fi

# Ask for Docker installation
echo -n "Do you want to install Docker? (y/n) "
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo_progress "Installing Docker..."

    # Add Docker's official GPG key:
    apt-get update
    apt-get install ca-certificates curl
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update

    apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

    echo_progress "Docker installed."
else
    echo_progress "Skipping Docker installation."
fi

# Installing zsh
echo_progress "Installing zsh"
apt-get install zsh -y
chsh -s /usr/bin/zsh
echo_progress "zsh installed & set"

# Cloning GIT config
echo_progress "Cloning dotfiles from git"
yadm clone https://github.com/oliroche-git/dotfiles.git
echo_progress "dotfiles cloned."

echo_progress "Creating folders"
mkdir /folders
chmod 775 /folders
touch /folders/git_link.txt
cat https://github.com/oliroche-git/dotfiles.git > /folders/git_link.txt
echo_progress "Done"
