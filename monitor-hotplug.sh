#!/bin/bash

sleep 5
uid=$(id -u arjun)
export XDG_RUNTIME_DIR=/run/user/$uid
export DBUS_SESSION_BUS_ADDRESS=$XDG_RUNTIME_DIR/bus
export DISPLAY=":0"
export XAUTHORITY="/home/arjun/.Xauthority"

DEVICES=$(xrandr --prop | grep connected | cut -d' ' -f1,2)

#this while loop declare the $HDMI1 $VGA1 $LVDS1 and others if they are plugged in
while read dev status
do
  if [ "connected" == "$status" ]
  then
      dev=$(echo $dev | tr -d '-')
      echo $dev "connected"
      declare $dev="yes";
  else
      echo $dev "disconnected"
      #Disable output for disconnected devices
      sudo -E -u arjun xrandr --output $dev --off
  fi
done <<< "$DEVICES"

if [ ! -z "$DP12" -a ! -z "$DP22" ]
then
  echo "DP1-2 and DP2-2 are plugged in"
  # Check again to prevent a race condition causing this to fire twice.
  if [ ! -e /tmp/docked ]
  then
  	sudo -E -u arjun xrandr --output DP1-2 --off
  	sudo -E -u arjun xrandr --output DP2-2 --off
  	sudo -E -u arjun /usr/bin/dock.sh
	touch /tmp/docked
  fi
elif [ ! -z "$DP11" -a -z "$DP12" ]; then
  echo "DP1-1 is plugged in."
  sudo -E -u arjun xrandr --output DP1-1 --off
  sudo -E -u arjun /usr/bin/dock-1080.sh
else
  echo "No external monitors are plugged in"
  sudo -E -u arjun xrandr --output eDP1 --mode 3200x1800 --primary --panning 3200x1800+0+0
  rm -rf /tmp/docked
fi

/usr/bin/setBackground.sh
