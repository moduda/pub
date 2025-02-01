#! /bin/sh
#

case $1 in
disable-all)	# when lid open lid or plug in charger while lid is open
	PREFVAL="%00"
	;;
disable-(openlid|open-lid))	# when lid open lid only 
	PREFVAL="%01"
	;;
disable-(plugin|plug-in))	# when charger while lid is open
	PREFVAL="%02"
	;;
reset)	# restore default settings
	sudo nvram -d BootPreference
	echo "% Reboot required to take changes take effect."
	exit
	;;
*)
	echo "Usage: $(basename $0) [ disable-all | disable-open-lid | disable-plug-in | reset ]"
	exit 1
	;;
esac

sudo nvram BootPreference="$PREFVAL"
echo "% Reboot required to take changes take effect."
