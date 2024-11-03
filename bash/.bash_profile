if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
startx ~/.xinitrc_i3
fi

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty2 ]]; then
startx ~/.xinitrc_dwm
fi

source /home/dmitry/.config/broot/launcher/bash/br
