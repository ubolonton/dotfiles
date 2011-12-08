# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME=""

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

# 
# Based on bira theme
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

local user_host='%{$terminfo[bold]$fg[green]%}%n@%m%{$reset_color%}'
local current_dir='%{$terminfo[bold]$fg[blue]%} %~%{$reset_color%}'

PROMPT="
╭─ ${user_host} ${current_dir}
╰─%B%b "
RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"

# 
# Editors
export EDITOR="emacsclient"
export SVN_EDITOR="emacsclient"

# Clojurescript setup
export CLOJURESCRIPT_HOME=/home/ubolonton/Programming/Tools/clojurescript
export PATH=$PATH:$CLOJURESCRIPT_HOME/bin

# Personal executable
export PATH=~/bin:$PATH

# Gem
export PATH=/var/lib/gems/1.8/bin:$PATH

alias ls='ls -aCFGlh --color'
alias df='df -h'
alias rs='rsync -rvz'
alias ec='emacsclient'

alias aptn='notify-send -t 2000 -i debian "apt-get:"'
alias upd='sudo apt-get update; aptn "Updated"'
alias upg='sudo apt-get upgrade; aptn "Upgraded"'
function ins {sudo apt-get install -y $* &&  aptn "Installed $@"}
function rem {sudo apt-get remove -y $* && aptn "Removed $@"}

# Warp
export PYTHONPATH=/home/ubolonton/Programming/Tools/warp
