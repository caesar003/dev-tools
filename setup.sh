#!/bin/bash

# ensure system is update

sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo apt autoremove -y
sudo apt install -y git tmux kitty build-essential ripgrep fd-find xdotool

# dont forget to install tpm, nodejs, python pip, yarn, pnpm, nvim node package, nvim python package

mkdir -p ~/.bin

ln -s ~/.dev-tools/.config/nvim ~/.config/nvim
ln -s ~/.dev-tools/.config/tmux ~/.config/tmux
ln -s ~/.dev-tools/.config/kitty ~/.config/kitty

ln -s ~/.dev-tools/.bin/dev-session.sh ~/.bin/devs
ln -s ~/.dev-tools/.bin/init-config.sh ~/.bin/iconfg
ln -s ~/.dev-tools/.bin/init-tmux.sh ~/.bin/itmx
ln -s ~/.dev-tools/.bin/toggle-kitty.sh ~/.bin/toggle-kitty

# chmod +x ~/.dev-tools./bin
chmod +x -R ~/.bin
