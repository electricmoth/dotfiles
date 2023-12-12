#!/bin/bash

# debugging
set -x


# make .config
[[ -d ~/.config ]] && echo "[*] found existing ~/.config dir" || mkdir -v ~/.config


# build-essential for gcc, nodejs for coc (autocomplete) in nvim
cli_tools=("bat" "build-essential" "curl" "matrix" "exiftool" "manpages-dev" "neomutt" "neovim" "neofetch" "nmap" "nodejs" "most" "pass" "ranger" "ripgrep" "sxiv" "tmux" "tty-clock" "unzip" "w3m"  "wget" "wireshark" "zathura" "zip" "zsh")

echo "install standard-issue terminal apps? (y/n/l = list apps)"
read install_tools]'
case $install_tools in
    y*)
        echo "[+] installing the usual cli tools"
        sudo apt install -y ${cli_tools}
        ;;
    l*)
        echo ${cli_tools[*]}
        ;;
    *)
        echo "[-] skipping cli_tools"
        ;;
esac


# TODO rm login screen

# -------------- SIGNAL MESSENGER ------------------------ #

echo "install signal? (y/n)"
read signal
if [[ $signal == y* ]]; then
    echo "[+] installing signal "
    # install signal official public software signing key:
    wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
    cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
    # add signal repository to list of repositories:
    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
      sudo tee /etc/apt/sources.list.d/signal-xenial.list
    # install Signal:
    sudo apt update && sudo apt install signal-desktop
else
    echo "[*] skipping signal"
fi

# ----------------------------------------------- #

# SESSION MESSENGER
echo "install session messenger (snap) (y/n)?"
read session
if [[ $session == y* ]]; then
    echo "[+] installing session"
    snap install session-desktop
else
    echo "[*] not installing session"
fi

# DOTFILES
# -d check if dir exists
[[ -d ~/dotfiles ]] && echo "[*] dotfiles found" || git clone https://github.com/electricmoth/dotfiles.git

# BAT (better cat, not to be confused with bettercap)
echo set BAT_THEME to "Catpuccin-macchiato? (y/n)"
read bat
if [[ $bat == y* ]]; then
    echo "[*] setting bat theme env var"
    export BAT_THEME="Catpuccin-macchiato" # can also be set in .config/bat/config
else
    echo "[*] skipping bat theme"
fi

# NODE
echo "install nodejs?"
read nodejs
if [[ $nodejs == y* ]]; then
    echo "[+] installing nodejs"
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && sudo apt-get install -y nodejs
else
    echo "[*] skipping nodejs"
fi

# VIM
# install vim-plug; `-f` checks if file exists and is a reg file
[[ -f ~/.vim/autoload/plug.vim ]] && echo "[*] vim-plug already installed" || curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# vim -c :PlugInstall
# vim -c :PlugUpdate

# TODO make backups of everything in new .conf, and then move dotfile/.config/* to ~/.config/. then remove individual cp commands

# NEOVIM
# get vim-plug
echo "install vim-plug for neovim? (y/n)"
read nvim_plug
if [[ $nvim_plug == y* ]]; then
    echo "[+] installing vim-plvug for neovim"
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    # copy init.vim from dotfiles
    mkdir -v ~/.config/nvim
    cp -vi ~/dotfiles/init.vim ~/.config/nvim/init.vim
    # install new plugins
    nvim -c ":PlugInstall"
else
    echo "[*] skipping vim-plug for neovim"
fi

# TMUX
echo "[*] install tpm for tmux? (y/n)"
read install_tpm
if [[ $install_tpm == y* ]]; then
    echo "[+] installing tpm for tmux"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    # get tmux.conf from dotfiles repo
    cp -vi ~/dotfiles/.config/tmux/tmux.conf ~/.config/tmux/tmux.conf
    # use new config file
    tmux source ~/.tmux.conf
    # install tpm plugins
    ~/.tmux/plugins/tpm/bin/install_plugins
else
    echo "[*] skipping tpm"
fi

# NEOFETCH
[[ -f ~/.config/neofetch/config.conf ]] && echo "[*] found existing neofetch config" || cp -vi ~/dotfiles/ ~/.config/neofetch/config.conf

# NERD-FONTS - Mononoki # TODO add others?

echo "install fonts? (y/n)"
read get_fonts
if [[ $get_fonts == y* ]]; then
    [ -d ~/.fonts ] && echo "directory ~/.fonts already exists" || mkdir -v ~/.fonts
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Mononoki.zip
    unzip Mononoki.zip -d ~/.fonts
    fc-cache -fv
else
    echo "[*] skipping fonts"
fi

# ZSH
# autosuggestions
echo "install zhs-autosuggestions? (y/n)"
read install_auto
if [[ $install_auto == y* ]]; then
    echo 'deb http://download.opensuse.org/repositories/shells:/zsh-users:/zsh-autosuggestions/xUbuntu_22.04/ /' | sudo tee /etc/apt/sources.list.d/shells:zsh-users:zsh-autosuggestions.list
    curl -fsSL https://download.opensuse.org/repositories/shells:zsh-users:zsh-autosuggestions/xUbuntu_22.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_zsh-users_zsh-autosuggestions.gpg > /dev/null
    sudo apt update
    sudo apt install zsh-autosuggestions
    # use .zshrc
    cp -vi ~/dotfiles/.zshrc ~/.zshrc
    # change default shell to zsh
    chsh -s $(which zsh)
else
    echo "[*] skipping zsh modifications"
fi

# SPLASH SCREEN
# remove "quiet splash" from /etc/default/grub, and also create a backup of orig with .bak suffix
echo "remove quiet boot? (y/n)"
read loud_boot
if [[ $loud_boot == y* ]]; then
    echo "[+] ditching quiet boot "
    # TODO check
    sudo sed -i.bak 's/quiet splash//' /etc/default/grub
else
    echo "[*] skipping remove quiet boot."
fi

# KEYBOARD
# remap caps to esc (mainly for [n]vim)
echo "remap capslock to escape? (y/n)"
read remap
if [[ $remap == y* ]]; then
    echo "[+] remapping capslock to esc (reboot to take effect)"
    sudo sed -i.bak 's/XKBOPTIONS=""/XKBOPTIONS="caps:escape"/' /etc/default/keyboard
else
    echo "[*] skipping key remap."
fi

# i3
echo "install i3? (y/n)"
read install_i3
if [[ $install_i3 == y* ]]; then
    echo "[+] installing i3..."
    sudo apt install i3-wm i3status suckless-tools i3lock nitrogen xcompmgr
else
    echo "[*] skipping i3 install."
fi

# DISABLE SERVICES
# TODO add bluetooth
unneeded=('modemmanager.service', 'avahi-daemon.service', 'avahi-daemon.socket', 'cups-browsed', 'rsyslog.service', 'whoopsie.path', 'cloud-config.service', 'cloud-init.service', 'cloud-init-local.service', 'cloud-final.service', 'cloud-init-hotplugd.socket', 'ubuntu-advantage.service')
echo ${unneeded}
echo "disable these services? (y/n)"
read disable
if [[ $disable == y* ]]; then
    echo "[+] disabling startup service $svc"
    for svc in unneeded;
     do
         sudo systemctl disable --now $svc
    done
else
    echo "[*] not disabling startup services"
fi
