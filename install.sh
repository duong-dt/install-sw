#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
source $HOME/.profile

cd ${TMPDIR:-/tmp}
# Find the base Ubuntu version
UBUNTU_VERSION=$(inxi -Sx | grep -iPo 'ubuntu [0-9]{2}\.[0-9]{2}' | tr -d '[:alpha:][:blank:]')

# Ask for sudo privilege
sudo -v || exit $?

# keep-alive sudo session
while true; do sleep 60; kill -0 "$$" || exit; sudo -v; done 2>/dev/null &

# ppa packages
sudo add-apt-repository ppa:mdoyen/homebank -y
sudo add-apt-repository ppa:qbittorrent-team/qbittorrent-stable -y
sudo add-apt-repository ppa:ubuntuhandbook1/vlc -y
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo add-apt-repository ppa:jonaski/strawberry -y

# Install pre-requisites first
sudo apt install -y curl wget lsb-release

# brave-browser release
# sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
# echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" \
# | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

# SourceGit repo
curl https://codeberg.org/api/packages/yataro/debian/repository.key | sudo tee /etc/apt/keyrings/sourcegit.asc
echo "deb [signed-by=/etc/apt/keyrings/sourcegit.asc, arch=amd64,arm64] https://codeberg.org/api/packages/yataro/debian generic main" \
| sudo tee /etc/apt/sources.list.d/sourcegit.list

# NodeJS repo
curl -fsSL https://deb.nodesource.com/setup_23.x | sudo bash -E

# deb-get
curl -sL https://raw.githubusercontent.com/wimpysworld/deb-get/main/deb-get | sudo -E bash -s install deb-get

# Nala
curl https://gitlab.com/volian/volian-archive/-/raw/main/install-nala.sh | bash

# Nala install script already run apt update and install nala
# sudo apt update

# common tool
sudo nala install -y \
jq xclip zbar-tools copyq gparted unrar \
vlc easytag easyeffects strawberry foliate \
git sourcegit zsh yakuake \
homebank qbittorrent \
borgbackup syncthing \
yt-dlp ffmpeg \
ibus ibus-gtk ibus-unikey ibus-hangul \
xapp-vorbiscomment-thumbnailer \
adb fastboot \
curl wget nodejs neovim \
python3-pip python3-pyfuse3 python3-venv

# oh-my-zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "oh-my-zsh already installed"
else
  echo "oh-my-zsh not yet installed"
  sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
fi

# VPN Client
deb-get install localsend bitwarden protonvpn \
  onlyoffice-desktopeditors ytdownloader

# Mega.nz Sync Client
echo
echo "Download & install MegaSync"
wget -o "${TMPDIR:-/tmp}/wget-megasync.log" --show-progress -O "megasync_amd64.deb" -c \
"https://mega.nz/linux/repo/xUbuntu_${UBUNTU_VERSION}/amd64/megasync-xUbuntu_${UBUNTU_VERSION}_amd64.deb" \
 && sudo nala install "$PWD/megasync_amd64.deb" -y

# Zoxide
echo
echo "Installing Zoxide"
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# eget
echo
echo "Download & install eget"
curl https://zyedidia.github.io/eget.sh | sh && mv $PWD/eget $HOME/.local/bin/eget

if [ -d "$HOME/.eget.toml" ]; then
  echo "~/.eget.toml already exists"
else
  echo "copy .eget.toml to ~"
  cp $DIR/.eget.toml $HOME/.eget.toml
fi

# Install others (in ~/.eget.toml) via eget
$HOME/.local/bin/eget -D

# Install python tool via uv
uv tool install vorta
uv tool install virtualenvwrapper

# Install flatpaks
flatpak install --noninteractive flathub app.zen_browser.zen
flatpak install --noninteractive flathub eu.betterbird.Betterbird

# Cleanup
sudo -k
rm $PWD/*.deb
