keyd-application-mapper -d

# export XMODIFIERS='@im=fcitx'
# export GTK_IM_MODULE=fcitx/xim
# export QT_IM_MODULE=fcitx
# fcitx5 -r -d --verbose '*=5'

export XIM=ibus
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export XIM_PROGRAM="ibus-daemon"
export XIM_ARGS="--daemonize --xim"
ibus-daemon --replace --xim --restart --daemonize
