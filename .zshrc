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
plugins=(npm pip kubectl zsh-syntax-highlighting colored-man-pages golang sbt cargo rust osx)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

# 
# My theme, based on bira theme
# NTA TODO: 256-color theme with fallback to 16-color

# It looks like the pair of %{ %} serves the purporse of preserving
# length or sth

# Virtualenv puts it before the prompt, which does not work well for
# my multi-prompt
VIRTUAL_ENV_DISABLE_PROMPT=TRUE
# NTA XXX: Why doesn't it work with left prompt?
function ublt/virtualenv-info {
    [ $VIRTUAL_ENV ] && echo "%{$fg[green]%} py%{$terminfo[bold]$fg[black]%}:%{$reset_color%}"`basename $VIRTUAL_ENV`
}

function ublt/nvm-info {
    [ $NVM_BIN ] && echo "%{$fg[green]%} js%{$terminfo[bold]$fg[black]%}:%{$reset_color%}"$(basename $(dirname $NVM_BIN))
}

function ublt/rbenv-info {
    if command_exists rbenv ; then
        echo "%{$fg[green]%} rb%{$terminfo[bold]$fg[black]%}:%{$reset_color%}"$(rbenv version-name)
    fi
}

function ublt/go-info {
    [ $gvm_go_name ] && echo "%{$fg[green]%} go%{$terminfo[bold]$fg[black]%}:%{$reset_color%}"$(echo $gvm_go_name | cut -d'o' -f 2)
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
    local virtual_env_info="$(ublt/virtualenv-info)"
    local nvm_info="$(ublt/nvm-info)"
    local rbenv_info="$(ublt/rbenv-info)"
    local go_info="$(ublt/go-info)"

    # Left, right, and second lines
    local   left="╭─ ${user_host}${virtual_env_info}${nvm_info}${go_info}${rbenv_info}"
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

function ublt/right-prompt {
    # Red exit code wrapped in [], nothing if exit code is 0
    local exit_code="%(?..[%{$fg[red]%}%?%{$reset_color%}])"

    # Set git prompt variables
    local ZSH_THEME_GIT_PROMPT_PREFIX="%{$terminfo[bold]$fg[magenta]%}"
    local ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
    local ZSH_THEME_GIT_PROMPT_DIRTY="%{$terminfo[bold]$fg[red]%} ✘"
    local ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$terminfo[bold]$fg[yellow]%} °"
    local ZSH_THEME_GIT_PROMPT_CLEAN="%{$terminfo[bold]$fg[green]%} ✔"
    # Get the actual prompt now
    local git_info="$(git_prompt_info)"

    local terminal="%l"

    echo "${exit_code} ${git_info} ${terminal}"
}

PROMPT='$(ublt/prompt)'
RPROMPT='$(ublt/right-prompt)'

#
# Personal key bindings for Dvorak layout (note that like my Emacs'
# bindings, these handle both cases: with and without Autokey's
# remapping)

# \e means "escape sequence". C-v then type to see

bindkey -e "\eh" backward-char
bindkey -e "\en" forward-char
bindkey -e "\eg" backward-word
bindkey -e "\er" forward-word

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


# 
# autojump ("j <partial name>")

if [[ $(uname) == "Darwin" ]]; then
    ublt_autojump_sh=/opt/local/etc/profile.d/autojump.sh
elif [[ $(uname) == "Linux" ]]; then
    ublt_autojump_sh=/usr/share/autojump/autojump.sh
fi

if [ -f $ublt_autojump_sh ]; then
    . $ublt_autojump_sh
fi

# 
# Colored, detailed listing

if [[ $(uname) == "Linux" ]]; then
    alias ls='ls -aCFho --color=auto'
elif [[ $(uname) == "Darwin" ]]; then
    alias ls='ls -aCFho -G'
fi

# 
# Useful aliases

alias utorrent="wine ~/.wine/drive_c/uTorrent.exe"

alias ec='emacsclient'

alias tailf='tail -f'

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
alias sc='lsof -nPi tcp | grep'            # Search connections
if [[ $(uname) == "Linux" ]]; then
    alias sk='sudo netstat -ntlp | grep'       # Search sockets
elif [[ $(uname) == "Darwin" ]]; then
    alias sk='sudo netstat -atp tcp | grep'       # Search sockets
fi


# File sync
alias rs='rsync -vv --progress -r'
alias rsl='rsync -vv --progress -r --inplace' # Local
alias rsn='rsync -vv --progress -rz'          # Network

# git log
# One-line id/author/message/time
alias gl="git log --abbrev-commit --date=relative --pretty=format:'%C(cyan)%h%Creset %C(green)%an%Creset %s %C(cyan)(%cr)%Creset'"
# Graph
alias gg="git log --abbrev-commit --graph --all --pretty=format:'%x20%C(cyan)%h%x20%C(green)%an%x20%Creset%s%C(yellow)%d%Creset'"
# Not merged to master
alias gm="git log --abbrev-commit --date=relative --pretty=format:'%C(cyan)%h%Creset %C(green)%an%Creset %s %C(cyan)(%cr)%Creset' HEAD --not master"


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

if [[ $(uname) == "Linux" ]]; then
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
    alias po='apt-cache policy'
    alias upd='sudo apt-get update; aptn "Updated"'
    alias upg='sudo apt-get upgrade; aptn "Upgraded"'
    function ins {
        sudo apt-get install -y $* &&  aptn "Installed $@"
    }
    function rem {
        sudo apt-get remove -y $* && aptn "Removed $@"
    }
    alias pf='dpkg -L'
elif [[ $(uname) == "Darwin" ]]; then
    # Search installed packages
    alias pi='port installed | grep'
    # Search all packages
    function pa () {
        port search $1 | grep $1
    }
    alias po='port info'
    alias upd='sudo port selfupdate'
    alias upg='sudo port upgrade outdated'
    function ins {
        sudo port -v install $*
    }
    function rem {
        sudo port -v uninstall $*
    }
    alias pf='port contents'
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
# Postgres & MySQL
alias createdb='createdb --encoding=utf8 --lc-ctype=en_US.utf8 --lc-collate=en_US.utf8 --template=template0'

alias mysql='mysql --pager=less'

#
# Run a simple http server (after optionally opening the browser if
# possible)

function server () {
    local port=${1:-1111} &&
    if command_exists gnome-open ; then # Linux
        gnome-open "http://localhost:${port}/"
    elif command_exists open ; then # Mac
        open "http://localhost:${port}/"
    fi &&
    python -m SimpleHTTPServer $port
}

# 
# Clojure
export LEIN_FAST_TRAMPOLINE=y
alias cljsbuild="lein trampoline cljsbuild $@"

# 
# Ruby (interactive tools only, so here, not .zshenv)

if [ -d "$HOME/.rbenv/bin" ] ; then
    ublt/add-path "$HOME/.rbenv/bin"
fi
if command_exists rbenv ; then
    eval "$(rbenv init -)"
fi

# 
if [ -s "$HOME/google-cloud-sdk/completion.zsh.inc" ] ; then
    source "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

if [ -s "$HOME/google-cloud-sdk/path.zsh.inc" ] ; then
    source "$HOME/google-cloud-sdk/path.zsh.inc"
fi

# 
# TODO XXX FIX HACK WTF F*ck /etc/profile calling path_helper

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
# XXX: Work around for jline issue
alias sbt="TERM=xterm sbt"
alias scala="TERM=xterm scala"
