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
# PATH

if [ -d "$HOME/.cabal/bin" ] ; then
    PATH="$HOME/.cabal/bin":$PATH
fi


if [[ $(uname) == "Linux" ]]; then
    # Use user's bin/
    PATH=~/bin:$PATH
elif [[ $(uname) == "Darwin" ]]; then
    # Use user's bin/ & gnu replacements
    PATH=~/bin:/opt/local/libexec/gnubin:/opt/local/bin:/opt/local/sbin:$PATH
fi

# Deduplication
typeset -U PATH
