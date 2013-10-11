# Editors
export EDITOR="emacsclient"
export SVN_EDITOR="emacsclient"

# Clojurescript setup
export CLOJURESCRIPT_HOME=/home/ubolonton/Programming/Clojure/lib/clojurescript
export PATH=$PATH:$CLOJURESCRIPT_HOME/bin

# Personal executable
export PATH=~/bin:$PATH

# Gem
# export PATH=/var/lib/gems/1.8/bin:$PATH

# Warp
export PYTHONPATH=/home/ubolonton/Programming/Tools/warp

# More colors
export TERM=xterm-256color

alias utorrent="wine ~/.wine/drive_c/uTorrent.exe"

# Seems unnecessary with ibus-qt4
# # Magic incantation for Skype to work with ibus-daemon?
# export GTK_IM_MODULE=ibus
# export XMODIFIERS=@im=ibus
# export QT_IM_MODULE=ibus
# export XIM_PROGRAM=/usr/bin/ibus-daemon
