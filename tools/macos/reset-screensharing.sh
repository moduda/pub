#! /bin/sh
#

case $1 in
stop)
	sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.screensharing.plist
	;;
start)
	sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.screensharing.plist
	;;
restart)
	$0 stop; $0 start
	;;
*)
	sudo launchctl print system/com.apple.screensharing
	;;
esac
