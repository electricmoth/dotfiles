#!/bin/bash

echo "~~~ installing terminal apps ~~~"
# build-essential for gcc, nodejs for coc (autocomplete) in nvim
sudo apt install build-essential curl cmatrix exiftool manpages-dev neomutt neovim neofetch nodejs pass ranger ripgrep tmux tty-clock w3m zathura zsh -y

# TODO install i3-gaps etc
# TODO no login screen?

# -------------- SIGNAL MESSENGER ------------------------ #

echo "~~~ installing signal ~~~"
# install signal official public software signing key:
wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null

# add signal repository to list of repositories:
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
  sudo tee /etc/apt/sources.list.d/signal-xenial.list

# install Signal:
sudo apt update && sudo apt install signal-desktop

# -----------------------

# SESSION
# TODO debug appimage
echo "~~~ installing session ~~~"
wget https://getsession.org/linux -O session.AppImage
chmod +x session.AppImage
sudo mv session.AppImage /opt/

# DOTFILES
[ -d ~/dotfiles ] && echo "~~~ dotfiles found ~~~" || echo "~~~ cloning dotfiles from github ~~~" && git clone https://github.com/electricmoth/dotfiles.git

# NODE
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && sudo apt-get install -y nodejs

# VIM
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


# NEOVIM
# get vim-plug
echo "~~~ installing vim-plug for neovim ~~~"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
# copy init.vim from dotfiles
mkdir -p ~/.config/nvim
cp ~/dotfiles/init.vim ~/.config/nvim/init.vim
# install new plugins
nvim -c ":PlugInstall"

# TMUX
echo " ~~~ installing tpm for tmux ~~~"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# get tmux.conf from dotfiles repo
cp ~/dotfiles/tmux.conf ~/.tmux.conf
# use new config file
tmux source ~/.tmux.conf

# NEOFETCH
cp ~/dotfiles/'neofetch config.conf' ~/.config/neofetch/config.conf

# NERD-FONTS
echo "~~~ downloading fonts ~~~"
[ -d ~/.fonts ] && echo "directory ~/.fonts already exists" || mkdir ~/.fonts && echo "creating ~/.fonts"
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Mononoki.zip
unzip Mononoki.zip -d ~/.fonts
fc-cache -fv

# ZSH
# TODO debug
# autosuggestions
echo 'deb http://download.opensuse.org/repositories/shells:/zsh-users:/zsh-autosuggestions/xUbuntu_22.04/ /' | sudo tee /etc/apt/sources.list.d/shells:zsh-users:zsh-autosuggestions.list
curl -fsSL https://download.opensuse.org/repositories/shells:zsh-users:zsh-autosuggestions/xUbuntu_22.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_zsh-users_zsh-autosuggestions.gpg > /dev/null
sudo apt update
sudo apt install zsh-autosuggestions
# use .zshrc
cp ~/dotfiles/.zshrc ~/.zshrc
# change default shell to zsh
chsh -s $(which zsh)

# SPLASH SCREEN
# remove "quiet splash" from /etc/default/grub, and also create a backup of orig with .bak suffix
echo "~~~ ditching quiet boot ~~~"
sudo sed -i.bak 's/quiet splash//' /etc/default/grub

