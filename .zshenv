# Editors
export EDITOR="emacsclient"
export SVN_EDITOR="emacsclient"

# More colors
export TERM=xterm-256color

######################################################################
# Utils

function command_exists () {
    type "$1" >/dev/null 2>&1 ;
}

function ublt/add-path {
    if [ -d "$1" ] ; then
        PATH="$1":$PATH
    fi
}

function ublt/maybe-load {
    [ -s "$1" ] && source "$1";
}

######################################################################
# ~/bin

function ublt/basic-path  {
    local system=`uname`
    if [[ $system == "Linux" ]]; then
        # Use user's bin/
        ublt/add-path "$HOME/bin"
    elif [[ $system == "Darwin" ]]; then
        # Use user's bin/ & gnu replacements
        ublt/add-path "/opt/local/sbin"
        ublt/add-path "/opt/local/bin"
        # ublt/add-path "/opt/local/libexec/gnubin"
        ublt/add-path "$HOME/bin"
    fi
}

ublt/basic-path

######################################################################
# Path deduplication
typeset -U PATH

######################################################################
# WTF https://www.google.com/search?q=python+ValueError%3A+unknown+locale%3A+UTF-8&ie=utf-8&oe=utf-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
