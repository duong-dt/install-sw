#!/bin/bash
# DIR="$(cd "$(dirname "$0")" && pwd)"
# source $HOME/.profile

# cd ${TMPDIR:-/tmp}

# Ask for sudo privilege
sudo -v || exit $?

# keep-alive sudo session
while true; do sleep 60; kill -0 "$$" || exit; sudo -v; done 2>/dev/null &

# Install packages from Arch repo
sudo pacman -Syu --noconfirm \
jq zbar unrar \
git zsh yakuake wl-clipboard \
android-tools \
vlc celluloid easytag easyeffects strawberry \
qt6ct \
komikku calibre okular \
homebank qbittorrent \
vorta borg syncthing kdiff3 \
localsend bitwarden proton-vpn-gtk-app \
onlyoffice-bin zen-browser-bin betterbird-bin \
mission-center octopi \
cachyos-gaming-meta lutris steam \
fcitx5 fcitx5-configtool fcitx5-unikey fcitx5-mozc \
distrobox toolbox podman \
fd fzf ripgrep bat micro \
zoxide uv lazygit just yazi \
ttf-firacode-nerd \
curl wget nodejs neovim \
python-pyfuse3

# Install packages from AUR
paru -S --noconfirm \
sourcegit-bin megasync-bin

# Install tools from uv
uv tool install virtualenvwrapper

