#!/bin/bash
#source $HOME/.profile

cd ${TMPDIR:-/tmp}
# Find the base Ubuntu version
#UBUNTU_VERSION=$(inxi -Sx | grep -iPo 'ubuntu [0-9]{2}\.[0-9]{2}' | tr -d '[:alpha:][:blank:]')

# Ask for sudo privilege
sudo -v || exit $?

# keep-alive sudo session
while true; do sleep 60; kill -0 "$$" || exit; sudo -v; done 2>/dev/null &



to_remove=(\
cachyos-fish-config fish fisher fish-pure-prompt fish-autorepair \
eza expac shelly meld \
kdeconnect kcontacts kpeople kwalletmanager \
cachyos-plymouth-bootanimation cachyos-plymouth-theme plymouth\
)

printf "%s\n" "${to_remove[@]}" > cachyos-remove.lst

sudo pacman -Runs --noconfirm $(pacman -Qq | rg -F -f cachyos-remove.lst)
