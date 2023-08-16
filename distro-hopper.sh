#!/bin/bash

echo "~~~ installing terminal apps ~~~"
# build-essential for gcc, nodejs for coc (autocomplete) in nvim
sudo apt install bat build-essential curl cmatrix exiftool manpages-dev neomutt neovim neofetch nmap nodejs most pass ranger ripgrep sxiv tmux tty-clock w3m wireshark zathura zsh -y

# TODO rm login screen

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
echo "~~~ installing session ~~~"
snap install session-desktop

# DOTFILES
[ -d ~/dotfiles ] && echo "~~~ dotfiles found ~~~" || echo "~~~ cloning dotfiles from github ~~~" && git clone https://github.com/electricmoth/dotfiles.git

# BAT (better cat, not to be confused with bettercap)
export BAT_THEME="Catpuccin-macchiato" # can also be set in .config/bat/config

# NODE
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && sudo apt-get install -y nodejs

# VIM
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# TODO make backups of everything in new .conf, and then move dotfile/.config/* to ~/.config/. then remove individual cp commands

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


# KEYBOARD
# remap caps to esc (mainly for vim)
echo "~~~ remapping capslock to esc (reboot to take effect) ~~~"
sudo sed -i.bak 's/XKBOPTIONS=""/XKBOPTIONS="caps:escape"/' /etc/default/keyboard

# i3
echo "install i3?"
read install_i3
if [[ $install_i3 == y* ]]; then
    echo "installing i3..."
    sudo apt install i3-wm i3status suckless-tools i3lock nitrogen xcompmgr
else
    echo "not installing i3."
fi

