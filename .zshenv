# Editors
export EDITOR="emacsclient"
export SVN_EDITOR="emacsclient"

# Clojurescript setup
export CLOJURESCRIPT_HOME=/home/ubolonton/Programming/Clojure/lib/clojurescript
export PATH=$PATH:$CLOJURESCRIPT_HOME/bin

# Personal executable
export PATH=~/bin:$PATH

# Gem
export PATH=/var/lib/gems/1.8/bin:$PATH

# Warp
export PYTHONPATH=/home/ubolonton/Programming/Tools/warp

# More colors
export TERM=xterm-256color

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

alias utorrent="wine ~/.wine/drive_c/uTorrent.exe"
