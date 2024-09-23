#!/bin/bash

# Update and upgrade system packages
sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y

# Install essential packages
sudo apt install -y git curl moc gh ripgrep nodejs python3 tmux kitty \
	build-essential gettext xclip python3-pip gofmt shfmt stylua fd-find \
	snapd lua5.1 xdotool php php-xml php-sqlite3 composer default-jdk \
	default-jre ninja-build gettext cmake unzip mariadb-server postgresql \
	postgresql-contrib

# Move or create environment configuration files
mv ~/.bashrc ~/.bashrc_bak
ln -s ~/.dev-tools/bashrc ~/.bashrc

# Clone personal tools repository
git clone https://github.com/caesar003/dev-tools

# Create backup and link configuration files and tools
ln -s ~/.dev-tools/.bin ~/.bin

mv ~/.config/nvim ~/.config/nvim_back
mv ~/.config/kitty ~/.config/kitty_back
mv ~/.config/tmux ~/.config/tmux_back

ln -s ~/.dev-tools/.config/nvim ~/.config/nvim
ln -s ~/.dev-tools/.config/tmux ~/.config/tmux
ln -s ~/.dev-tools/.config/kitty ~/.config/kitty

# Clone tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install Git and configure
git config --global user.name "caesar003"
git config --global user.email "caesarmuksid@gmail.com"
git config --global core.editor vim

# Install Node.js and global npm packages
curl -sL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Rust and Cargo
curl https://sh.rustup.rs -sSf | sh

# Install Go
cd
wget https://go.dev/dl/go1.23.1.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.23.1.linux-amd64.tar.gz
rm go1.23.1.linux-amd64.tar.gz

# Install Luarocks
cd
wget https://luarocks.org/releases/luarocks-3.11.1.tar.gz
tar zxpf luarocks-3.11.1.tar.gz
cd luarocks-3.11.1
./configure && make && sudo make install
cd

# Clone and build Neovim
git clone https://github.com/neovim/neovim.git ~/neovim-repo
cd ~/neovim-repo
git checkout stable
make CMAKE_BUILD_TYPE=RelWithDebInfo
cd build && cpack -G DEB && sudo dpkg -i nvim-linux64.deb
cd

# Clone and build Vim
git clone https://github.com/vim/vim ~/vim-repo

# Install Vim build dependencies
sudo apt-get build-dep vim -y

cd ~/vim-repo
./configure --with-features=huge \
	--enable-multibyte \
	--enable-rubyinterp \
	--enable-python3interp \
	--with-python3-config-dir=/usr/lib/python3.11/config-3.11-x86_64-linux-gnu/ \
	--enable-perlinterp --enable-luainterp \
	--enable-cscope \
	--enable-gtk2-check \
	--with-x
--with-compiledby="caesar003 - github.com/caesar003" \
	--disable-gui \
	--prefix=$PREFIX
make VMRUNTIMEDIR=/usr/share/vim/vim9
sudo make install
cd

# Install Chrome browser
cd
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome*.deb
cd

# Install LazyGit
cd
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin

# Install Gdu
curl -L https://github.com/dundee/gdu/releases/latest/download/gdu_linux_amd64.tgz | tar xz
chmod +x gdu_linux_amd64
sudo mv gdu_linux_amd64 /usr/bin/gdu

# Install Bottom
cd
curl -LO https://github.com/ClementTsang/bottom/releases/download/0.9.6/bottom_0.9.6_amd64.deb
sudo dpkg -i bottom_0.9.6_amd64.deb

# Install Remmina
sudo snap install remmina

# Install Nerd Fonts
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/DroidSansMono/DroidSansMNerdFont-Regular.otf
cd

# Install additional Python and npm packages
sudo pip3 install pynvim --break-system-packages
sudo npm install -g neovim yarn serve live-server neovim tree-sitter tree-sitter-cli

# Final cleanup
rm -f ~/luarocks-3.11.1.tar.gz
rm -f ~/google-chrome*.deb
rm -f ~/bottom*.deb
rm -rf ~/luarocks-3.11.1
rm -f ~/luarocks*.gz
rm -f ~/google-chrome*.deb
rm -f ~/lazygit ~/lazygit*.gz

sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo apt autoremove
