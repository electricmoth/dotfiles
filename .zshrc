# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename '/home/arch/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install


## Aliases
alias ls="ls --color -F"
alias ll="ls --color -lh"
alias la="ls --color -a -F"

alias grep='grep --color=auto'

alias ..='cd ..'
alias ~='cd ~'

### prompt customization

autoload -Uz promptinit
promptinit
prompt adam2

neofetch

# auto-suggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh


