#!/usr/bin/zsh
export DBUS_SESSION_BUS_ADDRESS=/run/user/1000/bus
export DISPLAY=:0
export XAUTHORITY=/home/arjun/.Xauthority
export XDG_RUNTIME_DIR=/run/user/1000

export numMonitors=$(xrandr --listmonitors | grep -v Monitors | wc -l)

feh $(printf "--bg-scale /home/arjun/wallpapers/haskell-1920x1080.png "%0.s {1..$numMonitors})
