system=`uname`

######################################################################

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
plugins=(pip kubectl colored-man-pages cargo rust osx aws)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

HISTSIZE=10000000
SAVEHIST=$HISTSIZE

######################################################################
# My theme, based on bira theme
# NTA TODO: 256-color theme with fallback to 16-color

# It looks like the pair of %{ %} serves the purporse of preserving length or sth.

function ublt/py-info {
    [ $VIRTUAL_ENV ] && echo "%{$fg[green]%} py%{$terminfo[bold]$fg[black]%}:%{$reset_color%}"`basename $VIRTUAL_ENV`
}

function ublt/js-info {
    [ $NVM_BIN ] && echo "%{$fg[green]%} js%{$terminfo[bold]$fg[black]%}:%{$reset_color%}"$(basename $(dirname $NVM_BIN))
}

function ublt/rb-info {
    if command_exists rbenv ; then
        echo "%{$fg[green]%} rb%{$terminfo[bold]$fg[black]%}:%{$reset_color%}"$(rbenv version-name)
    fi
}

function ublt/go-info {
    [ $gvm_go_name ] && echo "%{$fg[green]%} go%{$terminfo[bold]$fg[black]%}:%{$reset_color%}"$(echo $gvm_go_name | cut -d'o' -f 2)
}

function ublt/rs-info {
    if command_exists rustc ; then
        echo "%{$fg[green]%} rs%{$terminfo[bold]$fg[black]%}:%{$reset_color%}"$(rustc -V | cut -d' ' -f 2)
    fi
}

function ublt/date {
    date '+%a %Y-%m-%d %T %Z'
}

# Returns size excluding color codes and stuff
# Better than ${#${(%):-${str}}}
function ublt/size {
    # I hate this
    # http://stackoverflow.com/questions/10564314/count-length-of-user-visible-string-for-zsh-prompt
    local zero='%([BSUbfksu]|([FB]|){*})'
    local str=$1
    echo ${#${(S%%)str//$~zero/}}
}

# Multi-line prompt. Note that the normal right-prompt approach does
# not work since it appears on the last line of the prompt. Therefore
# some calculation is needed to get a part of the prompt right-aligned
function ublt/prompt {
    local user="%n"
    local host="%M"
    local user_host="%{$terminfo[bold]$fg[green]%}${user}%{$fg[black]%}@%{$fg[red]%}${host}%{$reset_color%}"
    local date_time="%{$terminfo[bold]$fg[cyan]%}$(ublt/date)%{$reset_color%}"
    local py_info="$(ublt/py-info)"
    local js_info="$(ublt/js-info)"
    local rb_info="$(ublt/rb-info)"
    local go_info="$(ublt/go-info)"
    local rs_info="$(ublt/rs-info)"

    # Left, right, and second lines
    local   left="╭─ ${user_host}${rs_info}${py_info}${js_info}${go_info}${rb_info}"
    local second="╰─%B%b "
    local right="${date_time}"

    # Length of middle part
    local max_length
    (( max_length = ${COLUMNS} - $(ublt/size $right) - $(ublt/size $left) - 4 ))

    # Construct a middle part of appropriate length that will make the
    # right part right-aligned
    local current_dir="%~"
    local dir_name_size=$(ublt/size $current_dir)
    if [[ $max_length -gt $dir_name_size ]]; then
        # Fill remaining spaces with ─────
	    local fill_bar="${(l.(($max_length - $dir_name_size))..─.)}"
        local middle="%{$terminfo[bold]$fg[blue]%}${current_dir}%{$reset_color%} %{$fg[magenta]%}${fill_bar}%{$reset_color%}"
    else
        # Or cut off if dir name is too long
        local middle="%{$terminfo[bold]$fg[magenta]%}%${max_length}<··· <%{$terminfo[bold]$fg[blue]%}${current_dir}%<<"
    fi

    echo "
${left} ${middle} ${right}
${second}"
}

ublt/exit-code() {
    if [ $? == 0 ]; then
        echo 😃
    else
        echo 😱
    fi
}

function ublt/right-prompt {
    # Red exit code wrapped in [], nothing if exit code is 0
    local exit_code="%(?.😃.😱 [%{$fg[red]%}%?%{$reset_color%}])"

    # Set git prompt variables
    local ZSH_THEME_GIT_PROMPT_PREFIX="%{$terminfo[bold]$fg[magenta]%}"
    local ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
    local ZSH_THEME_GIT_PROMPT_DIRTY="%{$terminfo[bold]$fg[red]%} ✘"
    local ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$terminfo[bold]$fg[yellow]%} °"
    local ZSH_THEME_GIT_PROMPT_CLEAN="%{$terminfo[bold]$fg[green]%} ✔"

    local terminal="%l"

    echo "${exit_code} ${terminal}"
}

######################################################################
# This is is loaded before custom key bindings, since fzf binds some keys which I want to override.
if [[ $system == "Darwin" ]]; then
    ublt/maybe-load /opt/local/share/fzf/shell/key-bindings.zsh
elif [[ $system == "FreeBSD" ]]; then
    eval "$(fzf --zsh 2>/dev/null)" || ublt/maybe-load /usr/local/share/examples/fzf/shell/key-bindings.zsh
elif [[ $system == "Linux" ]]; then
    eval "$(fzf --zsh 2>/dev/null)" ||
        ublt/maybe-load /usr/share/doc/fzf/examples/completion.zsh &&
            ublt/maybe-load /usr/share/doc/fzf/examples/key-bindings.zsh
fi
ublt/maybe-load "$HOME/.fzf.zsh"
bindkey '^T' transpose-chars

######################################################################
if command_exists sk ; then
    alias sk="sk --bind 'alt-c:up,alt-t:down,alt-g:backword-word,alt-r:forward-word,alt-h:backward-char,alt-n:forward-char,alt-d:beginning-of-line,alt-i:kill-line,alt-.:backword-kill-word,alt-p:kill-word'"
    alias skg="sk --ansi -c 'rg --color=always --line-number \"{}\"'"
fi
######################################################################

# Personal key bindings for Dvorak layout (note that like my Emacs'
# bindings, these handle both cases: with and without Autokey's
# remapping)

# \e means "escape sequence". C-v then type to see

# macOS conventions
bindkey -e "^X@sc" copy-region-as-kill
bindkey -e "^X@sx" kill-region
bindkey -e "^X@sv" yank
bindkey -e "^X@sz" undo
bindkey -e "^X@sZ" redo

# M-SPC
bindkey -e "^[ " set-mark-command

bindkey -e "\eh" backward-char
bindkey -e "\en" forward-char
# Translated by Kitty already.
# bindkey -e "\eg" backward-word
# bindkey -e "\er" forward-word

bindkey -e "\ee" backward-delete-char
bindkey -e "\eu" delete-char
# Translated by Kitty already.
# bindkey -e "\e." backward-kill-word
# bindkey -e "\ep" kill-word

# Translated by Karabiner/keyd.
# bindkey -e "\ed" beginning-of-line
# bindkey -e "\eD" end-of-line

# Translated by lower layers.
# bindkey -e "\ei" kill-line
# bindkey -e "\eI" kill-whole-line

bindkey -e "\ec" up-history
bindkey -e "\et" down-history
bindkey -e "\em" up-history
bindkey -e "\ev" down-history

bindkey -e "\eG" beginning-of-buffer-or-history
bindkey -e "\eR" end-of-buffer-or-history

bindkey -e "\e\t" menu-complete
bindkey -e "\t" menu-complete
# Translated by lower layers
# bindkey -e "\eb" menu-complete

bindkey -e "\e " insert-last-word

bindkey -M isearch "\ec" history-incremental-search-backward
bindkey -M isearch "^[OA" history-incremental-search-backward
bindkey -M isearch "\et" history-incremental-search-forward
bindkey -M isearch "^[OB" history-incremental-search-backward
bindkey -M isearch "\em" history-incremental-search-backward
bindkey -M isearch "\ev" history-incremental-search-forward

# To "help" autokey
bindkey -e "^[[D" backward-word
bindkey -e "^[[C" forward-word
# C-<delete>: Works on most terminal emulators. If not, configure
bindkey -e "\e[3;5~" kill-word
# XXX: To use these, configure Konsole > Settings > Edit Current
# Profile > Keyboard: Backspace+Ctrl => \E[25~ (just type them in).
# Note that we don't use ";5" or ";*" because tmux refuses to forward
# them.
bindkey -e "\e[25~" backward-delete-char
bindkey -e "\e[26~" backward-kill-word
bindkey -e "\e[27~" kill-word

# XXX: WTF tmux
bindkey -e "\e[1~" beginning-of-line
bindkey -e "\e[4~" end-of-line

######################################################################
# TODO XXX FIX HACK WTF F*ck /etc/profile calling path_helper. This makes sure that
# /opt paths go before /usr paths.
ublt/basic-path

######################################################################
# autojump ("j <partial name>")

if [[ $system == "Darwin" ]]; then
    ublt_autojump_sh=/opt/local/etc/profile.d/autojump.sh
elif [[ $system == "Linux" ]]; then
    ublt_autojump_sh=/usr/share/autojump/autojump.sh
fi

ublt/maybe-load $ublt_autojump_sh

######################################################################
# Colored, detailed listing

if [[ $system == "Linux" ]]; then
    alias ls='ls -aCFho --color=auto'
elif [[ $system == "Darwin" ]]; then
    alias ls='ls -aCFho -G'
fi

if command_exists exa; then
    alias ls='exa -a -lbghmS'
fi

######################################################################
# Inspect disk
alias df='df -h'                           # File system usage
alias du='du -h'                           # File space usage
alias dus='du -s'                          # File space usage (summary)
alias dul='du -d1'                         # File space usage (sub dirs)

######################################################################
# Search
alias sp='ps -ef | grep'                   # Search processes
alias sc='lsof -nPi tcp | grep'            # Search connections
if [[ $system == "Linux" ]]; then
    alias sck='sudo netstat -ntlp | grep'       # Search sockets
elif [[ $system == "Darwin" ]]; then
    alias sck='sudo netstat -atp tcp | grep'       # Search sockets
fi

######################################################################
# File sync
alias rs='rsync -vv --progress -ar'
alias rsl='rsync -vv --progress -ar --inplace' # Local
alias rsn='rsync -vv --progress -arz'          # Network

######################################################################
# git
# One-line id/author/message/time
alias gl="git log --abbrev-commit --date=relative --pretty=format:'%C(cyan)%h%Creset %C(green)%an%Creset %s %C(cyan)(%cr)%Creset'"
# Graph
alias gg="git log --abbrev-commit --graph --all --pretty=format:'%x20%C(cyan)%h%x20%C(green)%an%x20%Creset%s%C(yellow)%d%Creset'"
# Not merged to master
alias gm="git log --abbrev-commit --date=relative --pretty=format:'%C(cyan)%h%Creset %C(green)%an%Creset %s %C(cyan)(%cr)%Creset' HEAD --not master"
# Fetch a github pull request's refs
alias gp=ublt/github-fetch-pull-request
function ublt/github-fetch-pull-request {
    local remote=${2:-origin}
    git fetch $remote +refs/pull/$1/*:refs/remotes/$remote/pull/$1/*
}


######################################################################
# List
alias lc='lsof -nPi tcp'                   # List connections
alias l.='ls -d .*'                        # List dot files

######################################################################
# Other
alias ec='emacsclient'
alias ee="emacsclient -a '' -e"
alias tailf='tail -f'

######################################################################
# Package manager shortcuts
if [[ $system == "Linux" ]]; then
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
        apt-cache search --names-only $1 | grep -i $1
    }
    function po () {
        apt-cache showpkg $1
        echo
        apt-cache show $1
        apt-cache policy $1
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
elif [[ $system == "Darwin" ]]; then
    # Search installed packages
    alias pi='port installed | grep'
    # Search all packages
    function pa () {
        port search $1 | grep -i $1
    }
    function po () {
        port info $1
        echo
        port -vq installed $1
    }
    # unalias po
    alias upd='sudo port -v selfupdate'
    alias upg='sudo port -v upgrade outdated'
    function ins {
        sudo port -v install $*
    }
    function rem {
        sudo port -v uninstall --follow-dependencies $*
    }
    alias pf='port contents'
fi

######################################################################
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

######################################################################
# Pretty-print json
function ppjs () {
    if command_exists pygmentize ; then
        python -mjson.tool $1 | pygmentize -l json
    else
        python -mjson.tool $1
    fi
}

######################################################################
# Run a simple http server (after optionally opening the browser if possible)
function server () {
    local port=${1:-1111} &&
    if command_exists gnome-open ; then # Linux
        gnome-open "http://localhost:${port}/"
    elif command_exists open ; then # Mac
        open "http://localhost:${port}/"
    fi &&
    python -m SimpleHTTPServer $port
}

######################################################################
# PHP
ublt/add-path "$HOME/.composer/vendor/bin"

######################################################################
# Ruby
ublt/add-path "$HOME/.rbenv/bin"
if command_exists rbenv ; then
    eval "$(rbenv init -)"
fi

######################################################################
# Go
ublt/maybe-load "$HOME/.gvm/scripts/gvm"
export GOPATH="$HOME/go"
ublt/add-path $GOPATH/bin

######################################################################
# Python
# Virtualenv puts it before the prompt, which does not work well for my multi-prompt.
VIRTUAL_ENV_DISABLE_PROMPT=TRUE

if [ -d "$HOME/.pyenv" ] ; then
    export PYENV_ROOT="$HOME/.pyenv"
    ublt/add-path "$PYENV_ROOT"/bin
    eval "$(pyenv init -)"
fi

######################################################################
# Javascript

if [ -d "$HOME/.volta" ] ; then
   export VOLTA_HOME="$HOME/.volta"
   ublt/add-path "$VOLTA_HOME/bin"
else
    if [ -d "$HOME/.nvm" ] ; then
        export NVM_DIR="$HOME/.nvm"
        ublt/maybe-load "$NVM_DIR/nvm.sh"
    fi

    if [ -d "$HOME/.yarn/bin" ] ; then
        ublt/add-path "$HOME/.config/yarn/global/node_modules/.bin"
        ublt/add-path "$HOME/.yarn/bin"
    fi
fi

######################################################################
# Java
GRAALVM_BIN="/Library/Java/JavaVirtualMachines/openjdk11-graalvm/Contents/Home/bin"
# if [ -s $GRAALVM_BIN ] ; then
#     ublt/add-path $GRAALVM_BIN
# fi

export SDKMAN_DIR="$HOME/.sdkman"
ublt/maybe-load "$HOME/.sdkman/bin/sdkman-init.sh"

######################################################################
# Rust
if [ -s "$HOME/.cargo/bin/rustup" ] || command_exists cargo ; then
    ublt/add-path "$HOME/.cargo/bin"

    # Cache build artifacts.
    if command_exists sccache ; then
        export RUSTC_WRAPPER=sccache
    fi
fi

if command_exists starship ; then
    eval "$(starship init zsh)"
else
    PROMPT='$(ublt/prompt)'
    RPROMPT='$(ublt/right-prompt)'
fi

######################################################################
# gcloud
ublt/maybe-load "$HOME/google-cloud-sdk/path.zsh.inc"
ublt/maybe-load "$HOME/google-cloud-sdk/completion.zsh.inc"

######################################################################
# Additional completions
if [ -d "$HOME/.zfunc" ] ; then
    fpath+="$HOME/.zfunc"
    autoload -U compinit && compinit
fi

######################################################################
# XXX: Work around for jline issue
alias sbt="TERM=xterm sbt"
alias scala="TERM=xterm scala"

######################################################################
if [[ $system == "Darwin" ]]; then
    alias emacs=/Applications/EmacsMac.app/Contents/MacOS/Emacs
fi

######################################################################
#
if [[ $system == "Darwin" ]]; then
    export CPATH="/opt/local/include"
    export LIBRARY_PATH="/opt/local/lib"
fi

######################################################################
unset system

ublt/add-path "$HOME"/.local/bin

# Docker sucks less with this setting.
export DOCKER_BUILDKIT=1

######################################################################
# Path deduplication
typeset -U PATH

ublt/maybe-load ~/dotfiles/.local.zsh
