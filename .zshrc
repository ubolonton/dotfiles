# Ubuntu

# Terminal prompt
export PROMPT=$'\e[0;36m
❄ %T \e[1;36m %d
\e[0m' # zsh

# XXX: What's this?
zstyle ':completion:*' menu select=0
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s

# zsh autocomplete
autoload -U compinit
compinit

# Editors
export EDITOR="emacsclient"
export SVN_EDITOR="emacsclient"

# Clojurescript setup
export CLOJURESCRIPT_HOME=/home/ubolonton/Programming/Tools/clojurescript
export PATH=$PATH:$CLOJURESCRIPT_HOME/bin

# Personal executable
export PATH=~/bin:$PATH

export PAGER=less

# Better color support for terminal appss
export TERM=xterm-256color

alias ls='ls -aCFGlh --color'
alias df='df -h'

alias aptn='notify-send -t 2000 -i debian "apt-get:"'
alias upd='sudo apt-get update; aptn "Updated"'
alias upg='sudo apt-get upgrade; aptn "Upgraded"'
function ins {sudo apt-get install -y $* &&  aptn "Installed $@"}
function rem {sudo apt-get remove -y $* && aptn "Removed $@"}
