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

local user_host='%{$terminfo[bold]$fg[green]%}%n%{$fg[black]%}@%{$fg[red]%}%M%{$reset_color%}'
local current_dir='%{$terminfo[bold]$fg[blue]%} %~%{$reset_color%}'

PROMPT="
╭─ ${user_host} ${current_dir}
╰─%B%b "
RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"

# 
function command_exists () {
    type "$1" >/dev/null 2>&1 ;
}

alias ls='ls -aCFGlh --color'
alias df='df -h'                     # File system usage
alias du='du -h'                     # File space usage
alias dus='du -s'                     # File space usage
alias rs='rsync -rvz'                # File sync
alias ec='emacsclient'
alias sk='sudo netstat -ntlp | grep' # Search processes listening on ports
alias pp='ps -ef | grep'

# apt-get utils
function aptn () {
    if command_exists notify-send ; then
        notify-send -t 2000 -i debian "apt-get:" $1
    else
        echo "apt-get: $1"
    fi
}
# Search installed packages
alias pi='dpkg -l | grep'
# Search all packages
function pa () {
    apt-cache search --names-only $1 | grep $1
}
alias upd='sudo apt-get update; aptn "Updated"'
alias upg='sudo apt-get upgrade; aptn "Upgraded"'
function ins {sudo apt-get install -y $* &&  aptn "Installed $@"}
function rem {sudo apt-get remove -y $* && aptn "Removed $@"}

# Run a simple http server (after optionally opening the browser if
# possible)
function server () {
    local port="${1:-1111}" &&
    if command_exists gnome-open ; then
        gnome-open "http://localhost:${port}/"
    fi &&
    python -m SimpleHTTPServer $port
}
