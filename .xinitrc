keyd-application-mapper -d

export XMODIFIERS='@im=fcitx'
export GTK_IM_MODULE=fcitx/xim
export QT_IM_MODULE=fcitx
fcitx5 -r -d --verbose '*=5'

stumpwm
