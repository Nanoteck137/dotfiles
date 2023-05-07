export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="af-magic"

plugins=(git)
# plugins+=(zsh-vi-mode)

source $ZSH/oh-my-zsh.sh

# User configuration

alias vim="nvim"
export EDITOR="nvim"

echo -ne '\e[1 q'

# neofetch
