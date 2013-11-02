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

# 
# PATH

if [[ $(uname) == "Linux" ]]; then
    # Use user's bin/
    PATH=~/bin:$PATH
elif [[ $(uname) == "Darwin" ]]; then
    # Use user's bin/ & gnu replacements
    PATH=~/bin:/opt/local/libexec/gnubin:/opt/local/bin:/opt/local/sbin:$PATH
fi

# Deduplication
typeset -U PATH
