keyd-application-mapper -d

# eval $(ssh-agent)
gpg-connect-agent /bye
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

export XMODIFIERS='@im=fcitx'
export GTK_IM_MODULE=fcitx/xim
export QT_IM_MODULE=fcitx
fcitx5 -r -d --verbose '*=5'

stumpwm
