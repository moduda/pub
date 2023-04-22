#! /bin/sh
#
# Burn the USB drive as a bootable installation MacOS device.
#
# 22.apr.22	ykim
#

case $1 in
"")
	echo "Listing of /Volumes:"
	ls -1 /Volumes
	read -p "** Select one and enter its name: " VOL
	VOL="/Volumes/$VOL"
	;;
*)
	if [ -d "/Volumes/$*" ]
	then
		VOL="/Volumes/$*"
	else
		VOL="$*"
	fi
	;;
esac

echo "Creating bootable USB on: $VOL"
sudo /Applications/Install\ macOS\ Ventura.app/Contents/Resources/createinstallmedia --volume "$VOL"
