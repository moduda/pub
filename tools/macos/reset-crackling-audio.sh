#! /bin/sh

case $1 in
restart)
	sudo launchctl stop com.apple.audio.coreaudiod && sudo launchctl start com.apple.audio.coreaudiod
	;;
*)
	sudo killall coreaudiod
	;;
esac


