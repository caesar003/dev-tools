#!/bin/bash

# Install Git, curl, and other packages
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl moc gh ripgrep nodejs python3 tmux kitty build-essential gettext xclip python3-pip

# Configure Git
git config --global user.name "caesar003"
git config --global user.email "caesarmuksid@gmail.com"

# Install Node.js 20.x
curl -sL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Chrome browser
cd 
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome*.deb
rm google-chrome*.deb

# Install additional packages
sudo pip3 install pynvim --break-system-packages
sudo npm install -g neovim tree-sitter tree-sitter-cli live-server

# Install LazyGit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm lazygit lazygit*.gz

# Install Gdu
curl -L https://github.com/dundee/gdu/releases/latest/download/gdu_linux_amd64.tgz | tar xz
chmod +x gdu_linux_amd64
sudo mv gdu_linux_amd64 /usr/bin/gdu

# Install Bottom
curl -LO https://github.com/ClementTsang/bottom/releases/download/0.9.6/bottom_0.9.6_amd64.deb
sudo dpkg -i bottom_0.9.6_amd64.deb
rm bottom*.deb

# Install Vim build dependencies
sudo apt-get build-dep vim -y

# Setup Vim and Neovim
mkdir -p ~/.vim/init
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Clone necessary configurations
git clone https://github.com/caesar003/kitty.conf.git ~/.config/kitty
git clone https://github.com/caesar003/vimrc ~/.vim/init
ln -s ~/.vim/init/init.vimrc ~/.vimrc

# Install Nerd Font
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts && curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/DroidSansMono/DroidSansMNerdFont-Regular.otf
cd

# Clone and build Neovim
git clone https://github.com/neovim/neovim.git ~/neovim-repo
cd ~/neovim-repo
git checkout v0.9.5
make CMAKE_BUILD_TYPE=RelWithDebInfo
cd build && cpack -G DEB && sudo dpkg -i nvim-linux64.deb
cd
rm -rfv ~/neovim-repo

# Clone and build Vim
git clone https://github.com/vim/vim ~/vim-repo
cd ~/vim-repo
./configure --with-features=huge \
            --enable-multibyte \
            --enable-rubyinterp \
            --enable-python3interp \
            --with-python3-config-dir=/usr/lib/python3.11/config-3.11-x86_64-linux-gnu/ \
            --enable-perlinterp \
            --enable-luainterp \
            --enable-cscope \
            --enable-gtk2-check \
            --with-x \
            --with-compiledby="caesar003 - github.com/caesar003" \
            --disable-gui \
            --prefix=$PREFIX

make VMRUNTIMEDIR=/usr/share/vim/vim9
sudo make install

echo "Installation completed successfully!"
