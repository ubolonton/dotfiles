# Editors
export EDITOR="emacsclient"
export SVN_EDITOR="emacsclient"

# More colors
export TERM=xterm-256color

# Seems unnecessary with ibus-qt4
# # Magic incantation for Skype to work with ibus-daemon?
# export GTK_IM_MODULE=ibus
# export XMODIFIERS=@im=ibus
# export QT_IM_MODULE=ibus
# export XIM_PROGRAM=/usr/bin/ibus-daemon

# # For open-jdk 6
# # http://www.haskell.org/haskellwiki/Xmonad/Frequently_asked_questions#Problems_with_Java_applications.2C_Applet_java_console
# export _JAVA_AWT_WM_NONREPARENTING=1

# export AWT_TOOLKIT=MToolkit

# 
# Utils

function command_exists () {
    type "$1" >/dev/null 2>&1 ;
}

function ublt/add-path {
    if [ -d "$1" ] ; then
        PATH="$1":$PATH
    fi
}

# 
# ~/bin

if [[ $(uname) == "Linux" ]]; then
    # Use user's bin/
    ublt/add-path "$HOME/bin"
elif [[ $(uname) == "Darwin" ]]; then
    # Use user's bin/ & gnu replacements
    ublt/add-path "/opt/local/sbin"
    ublt/add-path "/opt/local/bin"
    # ublt/add-path "/opt/local/libexec/gnubin"
    ublt/add-path "$HOME/bin"
fi

# 
# Haskell

ublt/add-path "$HOME/.cabal/bin"

# 
# Go version manager

if [ -s "$HOME/.gvm/scripts/gvm" ] ; then
    source "$HOME/.gvm/scripts/gvm"
fi

#
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


# 
# Node version manager

export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ] ; then
    source "$NVM_DIR/nvm.sh"
fi

# 
# Ruby version manager

# Load RVM into a shell session *as a function*
if [ -s "$HOME/.rvm/scripts/rvm" ] ; then
    source "$HOME/.rvm/scripts/rvm"
fi

# 
# PHP globally installed packages

ublt/add-path "$HOME/.composer/vendor/bin"

# # 
# Path deduplication

typeset -U PATH
