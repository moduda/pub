#! /bin/sh
#
# Find out the serial port # and connect using screen
#

PORTNAME=$(ls /dev/cu.* | grep serial)

[ -z "$PORTNAME" ] && echo "Failed to get serial port name." && exit 1

PORTSPEED=9600
case $1 in
[0-9]*)	PORTSPEED=$1 ;;
esac

echo "Connecting to $PORTNAME using screen; speed=$PORTSPEED
To end this screen session, enter: CTRL-A and then CTRL-D"
read -p "OK to proceed? " reply

case $reply in
[Yy]*)	;;
*)	echo "aborting."; exit ;;
esac

screen $PORTNAME $PORTSPEED
