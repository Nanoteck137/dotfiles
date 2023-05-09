export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="af-magic"

plugins=(git)
# plugins+=(zsh-vi-mode)

source $ZSH/oh-my-zsh.sh

# User configuration

alias vim="nvim"
export EDITOR="nvim"

alias lg="lazygit"

echo -ne '\e[2 q'

# neofetch
