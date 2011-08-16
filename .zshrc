# Ubuntu

# Terminal prompt
export PROMPT="%T [%c] $ " # zsh

# zsh autocomplete
autoload -U compinit
compinit

alias ls='ls -aCFG'

# Editors
export EDITOR="emacsclient"
export SVN_EDITOR="emacsclient"

export CLOJURESCRIPT_HOME=~/Programming/Tools/clojurescript
export PATH=$CLOJURESCRIPT_HOME/bin:$PATH

# Personal executable
export PATH=~/bin:$PATH

export TERM=xterm-256color

