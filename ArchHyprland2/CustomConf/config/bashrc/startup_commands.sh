if ! pgrep -f gnome-keyring-daemon > /dev/null ; then
    eval $(gnome-keyring-daemon --start)
fi

eval "$(starship init bash)"
