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

######################################################################
# ~/bin

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
unset system

######################################################################
# Haskell

ublt/add-path "$HOME/.cabal/bin"

######################################################################
# Go version manager

if [ -s "$HOME/.gvm/scripts/gvm" ] ; then
    source "$HOME/.gvm/scripts/gvm"
fi

######################################################################
# Python's default virtual environment

# XXX: Because virtualenv always "puts" its path at the beginning, and
# because rvm always "wants" its path at the beginning
case ":$PATH:" in
    *:$HOME/.virtualenvs/default/bin:*)
        ;;
    *)
        if [ -s "$HOME/.virtualenvs/default/bin/activate" ] ; then
            source "$HOME/.virtualenvs/default/bin/activate"
        fi
        ;;
esac


######################################################################
# Node version manager

export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ] ; then
    source "$NVM_DIR/nvm.sh"
fi

######################################################################
# Ruby version manager

# Load RVM into a shell session *as a function*
if [ -s "$HOME/.rvm/scripts/rvm" ] ; then
    source "$HOME/.rvm/scripts/rvm"
fi

######################################################################
# PHP globally installed packages

ublt/add-path "$HOME/.composer/vendor/bin"

######################################################################
# Go workspace's binaries
export GOPATH="$HOME/go"
ublt/add-path $GOPATH/bin

######################################################################
# Rust
if [ -s "$HOME/.cargo/bin/rustup" ] ; then
    ublt/add-path "$HOME/.cargo/bin"
    export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
fi

######################################################################
# Path deduplication

typeset -U PATH

######################################################################
# WTF https://www.google.com/search?q=python+ValueError%3A+unknown+locale%3A+UTF-8&ie=utf-8&oe=utf-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
