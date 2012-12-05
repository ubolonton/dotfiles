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
# plugins=(git knife macports node npm pip vagrant)
plugins=(git knife node npm pip vagrant)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

# 
# My theme, based on bira theme
# NTA TODO: 256-color theme with fallback to 16-color

# Manual display, otherwise
VIRTUAL_ENV_DISABLE_PROMPT=TRUE
# NTA XXX: Why doesn't it work with left prompt?
function ublt-virtualenv-info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`')'
}

function ublt-date {
    date '+%a %Y-%m-%d %T %Z'
}

function ublt-fill-bar {
    local term_width
    (( term_width = ${COLUMNS} - 1 ))

    local fill_bar=""
    local pwd_len=""

    # NTA TODO: Use $pwd_len & this
    # local pwdsize=${#${(%):-%~}}

    local user="%n"
    local host="%M"
    local current_dir="%~"
    local date="$(ublt-date)"

    # Left prompt's left part
    local left_left_prompt_size=${#${(%):-╭─ ${user}@${host} $(ublt-virtualenv-info) ${current_dir}}}
    # Left prompt's right part
    local left_right_prompt_size=${#${(%):-${date}}}
    local left_prompt_size
    (( left_prompt_size = ${left_left_prompt_size} + ${left_right_prompt_size} ))

    if [[ "$left_prompt_size" -gt $term_width ]]; then
	    ((pwd_len=$term_width - $left_prompt_size))
    else
	    fill_bar="${(l.(($term_width - $left_prompt_size - 6))..─.)}"
    fi

    echo "%{$fg[magenta]%}  ${fill_bar}  %{$reset_color%}"
}

# git variables
ZSH_THEME_GIT_PROMPT_PREFIX="%{$terminfo[bold]$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$terminfo[bold]$fg[red]%} ✘"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$terminfo[bold]$fg[yellow]%} °"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$terminfo[bold]$fg[green]%} ✔"

local user_host='%{$terminfo[bold]$fg[green]%}%n%{$fg[black]%}@%{$fg[red]%}%M%{$reset_color%}'
local virtual_env_info='$(ublt-virtualenv-info)'
local current_dir='%{$terminfo[bold]$fg[blue]%}%~%{$reset_color%}'
local fill_bar='$(ublt-fill-bar)'
local date_time='%{$terminfo[bold]$fg[cyan]%}$(ublt-date)%{$reset_color%}'
local return_code="%(?..%{$terminfo[bold]$fg[red]%}%? ↵%{$reset_color%})"

PROMPT="
╭─ ${user_host} ${virtual_env_info} ${current_dir} ${fill_bar} ${date_time}
╰─%B%b "

RPROMPT='${return_code} $(git_prompt_info) %l'

#
# Personal key bindings for Dvorak layout
bindkey -e "\eh" backward-char
bindkey -e "\en" forward-char
bindkey -e "\eg" backward-word
bindkey -e "\er" emacs-forward-word

bindkey -e "\ee" backward-delete-char
bindkey -e "\eu" delete-char
bindkey -e "\e." backward-kill-word
bindkey -e "\ep" kill-word

bindkey -e "\ed" beginning-of-line
bindkey -e "\eD" end-of-line

bindkey -e "\ei" kill-line
bindkey -e "\eI" kill-whole-line

bindkey -e "\ec" up-history
bindkey -e "\et" down-history

bindkey -e "\eG" beginning-of-buffer-or-history
bindkey -e "\eR" end-of-buffer-or-history

bindkey -e "\e\t" menu-complete
bindkey -e "\t" menu-complete
bindkey -e "\eb" menu-complete

bindkey -e "\e " insert-last-word

bindkey -M isearch "\ec" history-incremental-search-backward
bindkey -M isearch "\et" history-incremental-search-forward

# 

# Determine platform
local unamestr=$(uname)
local platform=""
if [[ $unamestr == "Linux" ]]; then
    platform="Linux"
elif [[ $unamestr == "Darwin" ]]; then
    platform="Mac"
fi

# PATH
if [[ $platform == "Linux" ]]; then
    PATH=~/bin:$PATH
elif [[ $platform == "Mac" ]]; then
    PATH=~/bin:/opt/local/libexec/gnubin:/opt/local/bin:/opt/local/sbin:$PATH
fi

# autojump
if [[ $platform == "Mac" ]]; then
    if [ -f /opt/local/etc/profile.d/autojump.sh ]; then
        . /opt/local/etc/profile.d/autojump.sh
    fi
elif [[ $platform == "Linux" ]]; then
    if [ -f /usr/share/autojump/autojump.sh ]; then
        . /usr/share/autojump/autojump.sh
    fi
fi

function command_exists () {
    type "$1" >/dev/null 2>&1 ;
}

alias ls='ls -aCFGlh --color=auto'
alias df='df -h'                     # File system usage
alias du='du -h'                     # File space usage
alias dus='du -s'                    # File space usage
alias ec='emacsclient'
alias sk='sudo netstat -ntlp | grep' # Search processes listening on ports
alias pp='ps -ef | grep'

# File sync
alias rs='rsync --progress -rv'
alias rsl='rsync --progress -rv --inplace' # Local
alias rsn='rsync --progress -rvz'          # Network

#
if [[ $platform == "Linux" ]]; then
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
    function ins {
        sudo apt-get install -y $* &&  aptn "Installed $@"
    }
    function rem {
        sudo apt-get remove -y $* && aptn "Removed $@"
    }
    alias pf='dpkg -L'
elif [[ $platform == "Mac" ]]; then
    function pa () {
        port search $1 | grep $1
    }
    alias upd='sudo port selfupdate'
    alias upg='sudo port upgrade outdated'
    function ins {
        sudo port -v install $*
    }
    function rem {
        sudo port -v uninstall $*
    }
fi


#

# Run a simple http server (after optionally opening the browser if
# possible)
function server () {
    local port="${1:-1111}" &&
    if command_exists gnome-open ; then # Linux
        gnome-open "http://localhost:${port}/"
    elif command_exists open ; then # Mac
        open "http://localhost:${port}/"
    fi &&
    python -m SimpleHTTPServer $port
}

#

# Python virtual env setup
if command_exists virtualenvwrapper.sh ; then
    source `which virtualenvwrapper.sh`
    PROJECT_HOME=~/projects
fi
