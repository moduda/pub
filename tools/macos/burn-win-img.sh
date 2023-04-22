#! /bin/sh
#
# Make bootable Windows ISO image.
#

case $1 in
"")	echo "Usage: $(basename $0) win-image.img"; exit 1;;
esac

[ ! -r $WINIMG ] && echo "Cannot read: $WINIMG" && exit 2

WINIMG="$1"

echo "*** Listing disk mounts:"
RESULT=$(diskutil list)
echo "$RESULT"
read -p "Enter disk name (if /dev/diskN, then enter diskN): " DISKNAME
DEVDISK=/dev/$DISKNAME
DEVRDISK=/dev/r$DISKNAME
UNMOUNT=""
if [ $(echo "$RESULT" | grep -wc "$DEVDISK") = 0 ]
then
	read -p "Disk - $DEVDISK - not mounted; ok to proceed (y/n)? " yesno
	case $yesno in
	[yY]*)	diskutil unmountDisk $DEVDISK; UNMOUNT=OK ;;
	*)	echo "Exiting."; exit ;;
	esac
else
	if diskutil unmountDisk $DEVDISK
	then
		UNMOUNT=OK
	else
		UNMOUNT=ERROR
	fi
fi

if [ "$UNMOUNT" = OK ]
then
	echo "sudo dd if=${WINIMG} of=${DEVRDISK} bs=1m"
	# sudo dd if="${WINIMG}" of="${DEVRDISK}" bs=1m
	sudo dd if="${WINIMG}" of="${DEVDISK}" bs=1m
else
	echo "Failed unmount $DEVRDISK; aborting."
	exit 3
fi

# #
#  6008  mkdir windows-iso
#  6009  mv Win10_21H2_English_x64.iso windows-iso
#  6010  cd windows-iso
#  6012  hdiutil convert -format UDRW -o ./Win10_21H2_English_x64.img Win10_21H2_English_x64.iso
#  6018  diskutil list
#  6019  diskutil unmountDisk /dev/disk4
#  6020  mv Win10_21H2_English_x64.img.dmg Win10_21H2_English_x64.img
#  6021  sudo dd if=Win10_21H2_English_x64.img of=/dev/rdisk4 bs=1m
