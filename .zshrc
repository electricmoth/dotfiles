# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename '/home/arch/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v


## Aliases
alias ls="ls --color -F"
alias ll="ls --color -lh"
alias la="ls --color -a -F"

alias grep='grep --color=auto'
# nav
alias ..='cd ..'
alias ~='cd ~'
alias obsid="cd ~/Documents/obsidian_notes"
alias py="cd ~/Documents/coding/python"
alias c="cd ~/Documents/coding/C"

alias py3="python3"
# config
alias zshrc="nvim ~/.zshrc"
alias tmuxrc="nvim ~/.tmux.conf"
alias nvimrc="nvim ~/.config/nvim/init.vim"

alias ip="ip -c"

### prompt customization
autoload -Uz promptinit
promptinit
prompt adam2

neofetch

# auto-suggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# config
echo "alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'" >> $HOME/.zshrc
