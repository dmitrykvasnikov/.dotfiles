#
# ~/.bashrc
#

HISTSIZE=5000
HISTFILESIZE=10000

eval "$(fzf --bash)"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Getting branch name
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

prompt_color='\[\033[34m\]'
info_color='\[\033[32m\]'
prompt_symbol=' 󰣇  '

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Two-liner prompt with git branch name
PS1=$prompt_color'┌──${VIRTUAL_ENV:+(\[\033[0m\]$(basename $VIRTUAL_ENV)'$prompt_color')}('$info_color'\u'$prompt_symbol'\h'$prompt_color')-[\[\033[0m\]\w'$prompt_color']\[\033[0;32m\]$(parse_git_branch)\[\033[0m\]\n'$prompt_color'└─'$info_color'\$\[\033[0m\] '
#PS1='[\u@\h \W]\$\[\033[0;36m\]$(parse_2:git_branch)\[\033[0m '

# Source aliases
source ~/.aliasrc

# Functions
mkcd(){
  mkdir "$1"
  cd "$1"
  pwd
}

lsmusic() {
  tree -d | grep -vE "[aA]rtwork|[sS]can|CD[0-9]|CD [0-9]|[Dd]isk|[Dd]isc" > "$1"
}

# Source nvm
source /usr/share/nvm/init-nvm.sh

export PROMPT_COMMAND="history -a"

export PATH="$HOME/.ghcup/bin:$HOME/.cabal/bin:$HOME/.scripts:$HOME/.local/bin:$HOME/.config/emacs/bin:~/.spoof-dpi/bin:/usr/local/go/bin:$PATH"

# FZF color sheme
export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'
export DOOMDIR="~/.config/doom"

# broot
source /home/dmitry/.config/broot/launcher/bash/br

# zoxide
eval "$(zoxide init bash)"
