#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Getting branch name
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

prompt_color='\[\033[;1;32m\]'
info_color='\[\033[1;34m\]'
prompt_symbol=' 󰣇  '

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Two-liner prompt with git branch name
PS1=$prompt_color'┌──${VIRTUAL_ENV:+(\[\033[0;1m\]$(basename $VIRTUAL_ENV)'$prompt_color')}('$info_color'\u'$prompt_symbol'\h'$prompt_color')-[\[\033[0;1m\]\w'$prompt_color']\[\033[0;36m\]$(parse_git_branch)\[\033[0m\]\n'$prompt_color'└─'$info_color'\$\[\033[0m\] '
#PS1='[\u@\h \W]\$\[\033[0;36m\]$(parse_2:git_branch)\[\033[0m '

# Source aliases
source .aliasrc

# Functions
mkcd(){
  mkdir "$1"
  cd "$1"
  pwd
}

# Source nvm
source /usr/share/nvm/init-nvm.sh

export PROMPT_COMMAND="history -a"

export PATH="$HOME/.ghcup/bin:$HOME/.cabal/bin:$HOME/.scripts:$HOME/.local/bin:$HOME/.config/emacs/bin:$PATH"
