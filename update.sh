#!/bin/bash
source $HOME/.profile

cd ${TMPDIR:-/tmp}
# Find the base Ubuntu version
UBUNTU_VERSION=$(inxi -Sx | grep -iPo 'ubuntu [0-9]{2}\.[0-9]{2}' | tr -d '[:alpha:][:blank:]')

# Ask for sudo privilege
sudo -v || exit $?

# keep-alive sudo session
while true; do sleep 60; kill -0 "$$" || exit; sudo -v; done 2>/dev/null &


# common tool
sudo nala install -y --update \
jq xclip zbar-tools copyq gparted unrar xarchiver nemo-compare \
vlc easytag easyeffects strawberry calibre \
git sourcegit zsh yakuake \
homebank qbittorrent \
borgbackup syncthing \
yt-dlp ffmpeg \
ibus ibus-gtk ibus-unikey ibus-hangul \
xapp-vorbiscomment-thumbnailer \
adb fastboot \
curl wget nodejs neovim \
python3-pip python3-pyfuse3 python3-venv \
dconf-cli \
nala megasync


sudo deb-get upgrade --dg-only

# Mega.nz Sync Client
# echo
# echo "Download & install MegaSync"
# wget -o "${TMPDIR:-/tmp}/wget-megasync.log" --show-progress -O "megasync_amd64.deb" -c \
# "https://mega.nz/linux/repo/xUbuntu_${UBUNTU_VERSION}/amd64/megasync-xUbuntu_${UBUNTU_VERSION}_amd64.deb" \
#  && sudo nala install "$PWD/megasync_amd64.deb" -y

# Zoxide
echo
echo "Installing Zoxide"
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# Install others (in ~/.eget.toml) via eget
$HOME/.local/bin/eget -D

# Install python tool via uv
uv tool install --upgrade vorta
uv tool install --upgrade virtualenvwrapper

# Install flatpaks
flatpak update app.zen_browser.zen --noninteractive
flatpak update eu.betterbird.Betterbird --noninteractive
flatpak update info.febvre.Komikku --noninteractive

# Cleanup
sudo -k
rm $PWD/*.deb
