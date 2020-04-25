#!/bin/bash

## Author : Aditya Shakya (adi1090x)
## Mail : adi1090x@gmail.com
## Github : @adi1090x
## Reddit : @adi1090x

case "$OSTYPE" in
	linux*) DIR="/usr/share/dynamic-wallpaper" ;;
	*) DIR="/usr/share/dynamic-wallpaper" ;;
esac

case "$OSTYPE" in
	linux*) TIME="$(date +%k)" ;;
	*) TIME="$(date +%k)" ;;
esac

## For XFCE
if [[ "$OSTYPE" == "linux"* ]]; then
    SCREEN="$(xrandr --listactivemonitors | awk -F ' ' 'END {print $1}' | tr -d \:)"
    MONITOR="$(xrandr --listactivemonitors | awk -F ' ' 'END {print $2}' | tr -d \*+)"
fi

case "$OSTYPE" in 
	linux*) if [ -n "$SWAYSOCK" ]; then SETTER="eval ogurictl output '*' --image"; 
	elif [[ "$DESKTOP_SESSION" =~ ^(MATE|Mate|mate)$ ]]; then SETTER="gsettings set org.mate.background picture-filename"; 
	elif [[ "$DESKTOP_SESSION" =~ ^(Xfce Session|xfce session|XFCE|xfce|Xubuntu|xubuntu)$ ]]; then SETTER="xfconf-query --channel xfce4-desktop --property /backdrop/screen$SCREEN/monitor$MONITOR/workspace0/last-image --set"; 
	elif [[ "$DESKTOP_SESSION" =~ ^(LXDE|Lxde|lxde)$ ]]; then SETTER="pcmanfm --set-wallpaper"; 
	elif [[ "$DESKTOP_SESSION" =~ ^(PANTHEON|Pantheon|pantheon|GNOME|Gnome|gnome|UBUNTU|Ubuntu|ubuntu|DEEPIN|Deepin|deepin)$ ]]; then SETTER="gsettings set org.gnome.desktop.background picture-uri"; 
	else SETTER="hsetroot -fill"; fi ;;
	*) if [ -n "$SWAYSOCK" ]; then SETTER="eval ogurictl output '*' --image"; 
	elif [[ "$DESKTOP_SESSION" =~ ^(MATE|Mate|mate)$ ]]; then SETTER="gsettings set org.mate.background picture-filename"; 
	elif [[ "$DESKTOP_SESSION" =~ ^(Xfce Session|xfce session|XFCE|xfce|Xubuntu|xubuntu)$ ]]; then SETTER="xfconf-query --channel xfce4-desktop --property /backdrop/screen$SCREEN/monitor$MONITOR/workspace0/last-image --set"; 
	elif [[ "$DESKTOP_SESSION" =~ ^(LXDE|Lxde|lxde)$ ]]; then SETTER="pcmanfm --set-wallpaper"; 
	elif [[ "$DESKTOP_SESSION" =~ ^(PANTHEON|Pantheon|pantheon|GNOME|Gnome|gnome|UBUNTU|Ubuntu|ubuntu|DEEPIN|Deepin|deepin)$ ]]; then SETTER="gsettings set org.gnome.desktop.background picture-uri"; 
	else SETTER="hsetroot -fill"; fi ;;
esac

## Available styles
##
## bitday, firewatch
STYLE=
NUMBER=24

function set_wallpaper {
    $SETTER $DIR/images/$STYLE/$1.png
}

function main {
    num=$(echo "scale=1; $TIME/24*$NUMBER" | bc | awk '{print int($1+0.5)}')
    set_wallpaper $num; sleep 10
}

function usage {
    available_styles=($(ls -d $DIR/images/*))
    echo -n "
Dynamic Wallpaper V1.0
Developed By - Aditya Shakya (@adi1090x)
-s, --style	=	style name
-n, --number	=	number of images in theme
-h, --help	=	show usage

Example: dwall -s=firewatch -n=24
Styles folder: $DIR/images/
Available styles:
"
for i in ${available_styles[@]}; do echo "$i" | rev | cut -d/ -f1 | rev | echo - "$(cat -)"; done
exit 1
}

function init {
    while true; do
        main && exec $DIR/dwall.sh -s=$STYLE -n=$NUMBER
    done
}

for i in "$@"
do
case $i in
    -s=*|--style=*)
    STYLE="${i#*=}"
    ;;
    -n=*|--number=*)
    NUMBER="${i#*=}"
    ;;
    -h|--help)
    usage
    ;;
    *)
    echo -n "Unknown option: $i"
    usage
    ;;
esac
done

if [[ ! -z "$STYLE" ]]; then
    init
else
    usage
fi
