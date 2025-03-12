#! /bin/sh
#

case $1 in
stop)
	sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.screensharing.plist
	;;
start)
	sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.screensharing.plist
	;;
restart|reset)
	$0 stop; $0 start
	;;
status)
	sudo launchctl print system/com.apple.screensharing
	;;
*)
	echo "$(basename $0) [ stop start restart status ]"
	exit 1
	;;
esac
