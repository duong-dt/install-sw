#!/bin/bash
source $HOME/.profile

cd ${TMPDIR:-/tmp}
# Find the base Ubuntu version
UBUNTU_VERSION=$(inxi -Sx | grep -iPo 'ubuntu [0-9]{2}\.[0-9]{2}' | tr -d '[:alpha:][:blank:]')

# Ask for sudo privilege
sudo -v || exit $?

# keep-alive sudo session
while true; do sleep 60; kill -0 "$$" || exit; sudo -v; done 2>/dev/null &

# remove not needed default apps from Mint
sudo apt-get remove --purge -y firefox firefox-locale-en hypnotix mintchat \
    rhythmbox rhythmbox-data rhythmbox-plugins rhythmbox-plugin-tray-icon \
    thunderbird thunderbird-locale-en thunderbird-locale-en-us \
    transmission-gtk transmission-common warpinator simple-scan sticky \
    drawing libreoffice-common pix pix-data pix-dbg seahorse thingy \

sudo apt-get autoremove
