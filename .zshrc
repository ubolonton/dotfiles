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
# Utils

function command_exists () {
    type "$1" >/dev/null 2>&1 ;
}

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

function ublt-prompt {
    local user="%n"
    local host="%M"
    local current_dir="%~"
    local date="$(ublt-date)"
    local virtual_env_info="$(ublt-virtualenv-info)"

    # NTA XXX: For some reason this does not work
    # local left_left_prompt_size_no_dir=${#${(%):-╭─ ${user}@${host} $(ublt-virtualenv-info)}}

    # Left prompt's left part
    local left_left_prompt_size=${#${(%):-╭─ ${user}@${host} ${virtual_env_info} ${current_dir}}}
    local dir_name_size=${#${(%):-${current_dir}}}
    local left_left_prompt_size_no_dir
    (( left_left_prompt_size_no_dir = $left_left_prompt_size - $dir_name_size ))
    # Left prompt's right part
    local left_right_prompt_size=${#${(%):-${date}}}

    local max_length
    (( max_length = ${COLUMNS} - $left_right_prompt_size - $left_left_prompt_size_no_dir - 3 ))
    if [[ $max_length -gt $dir_name_size ]]; then
        # Fill remaining spaces with ─────
	    local fill_bar="${(l.(($max_length - $dir_name_size - 2))..─.)}"
        local dir_and_stuff="%{$terminfo[bold]$fg[blue]%}${current_dir}%{$reset_color%} %{$fg[magenta]%} ${fill_bar} %{$reset_color%}"
    else
        # Or cut off if dir name is too long
        local dir_and_stuff="%{$terminfo[bold]$fg[magenta]%}%${max_length}<··· <%{$terminfo[bold]$fg[blue]%}${current_dir}%<< "
    fi

    local user_host="%{$terminfo[bold]$fg[green]%}${user}%{$fg[black]%}@%{$fg[red]%}${host}%{$reset_color%}"
    local date_time="%{$terminfo[bold]$fg[cyan]%}${date}%{$reset_color%}"

    echo "
╭─ ${user_host} ${virtual_env_info} ${dir_and_stuff} ${date_time}
╰─%B%b "
}

# git variables
ZSH_THEME_GIT_PROMPT_PREFIX="%{$terminfo[bold]$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$terminfo[bold]$fg[red]%} ✘"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$terminfo[bold]$fg[yellow]%} °"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$terminfo[bold]$fg[green]%} ✔"

PROMPT='$(ublt-prompt)'
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
bindkey -e "\em" up-history
bindkey -e "\ev" down-history

bindkey -e "\eG" beginning-of-buffer-or-history
bindkey -e "\eR" end-of-buffer-or-history

bindkey -e "\e\t" menu-complete
bindkey -e "\t" menu-complete
bindkey -e "\eb" menu-complete

bindkey -e "\e " insert-last-word

bindkey -M isearch "\ec" history-incremental-search-backward
bindkey -M isearch "\et" history-incremental-search-forward
bindkey -M isearch "\em" history-incremental-search-backward
bindkey -M isearch "\ev" history-incremental-search-forward

# 
# Determine platform

local unamestr=$(uname)
local platform=""
if [[ $unamestr == "Linux" ]]; then
    platform="Linux"
elif [[ $unamestr == "Darwin" ]]; then
    platform="Mac"
fi

# 
# PATH

if [[ $platform == "Linux" ]]; then
    # Use user's bin/
    PATH=~/bin:$PATH
elif [[ $platform == "Mac" ]]; then
    # Use user's bin/ & gnu replacements
    PATH=~/bin:/opt/local/libexec/gnubin:/opt/local/bin:/opt/local/sbin:$PATH
fi

# 
# autojump ("j <partial name>")

if [[ $platform == "Mac" ]]; then
    ublt_autojump_sh=/opt/local/etc/profile.d/autojump.sh
elif [[ $platform == "Linux" ]]; then
    ublt_autojump_sh=/usr/share/autojump/autojump.sh
fi

if [ -f $ublt_autojump_sh ]; then
    . $ublt_autojump_sh
fi

# 
# Colored, detailed listing

if [[ $platform == "Linux" ]]; then
    alias ls='ls -aCFho --color=auto'
elif [[ $platform == "Mac" ]]; then
    alias ls='ls -aCFho -G'
fi

# 
# Useful aliases

alias ec='emacsclient'

# Disk
alias df='df -h'                           # File system usage
alias du='du -h'                           # File space usage
alias dus='du -s'                          # File space usage (summary)
alias dul='du -d1'                         # File space usage (sub dirs)

# List
alias lc='lsof -nPi tcp'                   # List connections
alias l.='ls -d .*'                        # List dot files

# Search
alias sp='ps -ef | grep'                   # Search processes
alias sk='sudo netstat -ntlp | grep'       # Search sockets
alias sc='lsof -nPi tcp | grep'            # Search connections

# File sync
alias rs='rsync --progress -rv'
alias rsl='rsync --progress -rv --inplace' # Local
alias rsn='rsync --progress -rvz'          # Network

#
# Pretty-print json
function ppjs () {
    if command_exists pygmentize ; then
        python -mjson.tool $1 | pygmentize -l json
    else
        python -mjson.tool $1
    fi
}

#
# Package manager shortcuts

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
# Extract archive

function extract () {
    if [ -f $1 ] ; then
      case $1 in
        *.tar.bz2)   tar xjf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

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
# NTA: Slow, don't use for now
# # Python virtual env setup

# if command_exists virtualenvwrapper.sh ; then
#     source `which virtualenvwrapper.sh`
#     PROJECT_HOME=~/projects
# fi
