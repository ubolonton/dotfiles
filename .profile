
# MacPorts Installer addition on 2009-07-21_at_19:27:41: adding an appropriate PATH variable for use with MacPorts.
#export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.


# MacPorts Installer addition on 2009-07-21_at_19:27:41: adding an appropriate MANPATH variable for use with MacPorts.
export MANPATH=/opt/local/share/man:$MANPATH
# Finished adapting your MANPATH environment variable for use with MacPorts.

# TextMate/Emacs
export ALTERNATE_EDITOR="mate -w"
export EDITOR="/Applications/MacPorts/Emacs.app/Contents/MacOS/bin/emacsclient"
export SVN_EDITOR="mate -w"

# MySQL
export PATH=$PATH:/usr/local/mysql/bin

# Terminal prompt
# export PS1="\u [\W] $" # bash
# export PROMPT="%T [%~] $" # zsh

# Gradle path
#export PATH=$PATH:/Users/lonton/Tools/gradle-0.8/bin
#export GRADLE_HOME=/Users/lonton/Tools/gradle-0.8

# Cappuccino
export CAPP_BUILD="/Users/lonton/Tools/cappuccino/Build"

alias ls='ls -aCFG'

test -r /sw/bin/init.sh && . /sw/bin/init.sh

echo WTF
