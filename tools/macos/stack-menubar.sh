#!/bin/sh
#
# Adjust the padding/spacing between macOS menu icons.
# This helps to show more icons before they hide behind the camera notch.
#
# 11.oct.24	ykim
#

# Note: These values are not set by default. This means you will get an error
# that the keys and values do not exist if you have not previously set them.
readMenuItemSpacing() {
	case $1 in
	spacing)
		defaults -currentHost read -globalDomain NSStatusItemSpacing
		;;
	padding)
		defaults -currentHost read -globalDomain NSStatusItemSelectionPadding
		;;
	all)
		echo NSStatusItemSpacing: $(defaults -currentHost read -globalDomain NSStatusItemSpacing)
		echo NSStatusItemSelectionPadding: $(defaults -currentHost read -globalDomain NSStatusItemSelectionPadding)
		;;
	*)
		echo "Bad arg for readMenuItemSpacing()"
		return 1
		;;
	esac
}

# Remove the values to restore the default behavior:
deleteMenuItemSpacing() {
	defaults -currentHost delete -globalDomain NSStatusItemSpacing
	defaults -currentHost delete -globalDomain NSStatusItemSelectionPadding
	killall SystemUIServer
}

# arg1=NSStatusItemSpacing; arg2=NSStatusItemSelectionPadding
setMenuItemSpacing() {
	defaults -currentHost write -globalDomain NSStatusItemSpacing -int $1
	defaults -currentHost write -globalDomain NSStatusItemSelectionPadding -int $2
	killall SystemUIServer
}


# Initialize variables
SpacingVALUE=0
PaddingVALUE=0

case "$1" in
-s)
	# After some experimentation, I landed on the values above — 12 for spacing and 8
	# for padding fit my needs. You should experiment as well. The smallest tolerable
	# values are probably around 6 or 8.
	SpacingVALUE=${2:-12}
	PaddingVALUE=${3:-8}
	CurrentSPACING=$(readMenuItemSpacing spacing)
	CurrentPADDING=$(readMenuItemSpacing padding)
	[[ ! "$CurrentSPACING" =~ ^[0-9]+$ ]] && CurrentSPACING="Not set"
	[[ ! "$CurrentPADDING" =~ ^[0-9]+$ ]] && CurrentPADDING="Not set"
	echo "Current => New values:
	NSStatusItemSpacing: $CurrentSPACING => $SpacingVALUE
	NSStatusItemSelectionPadding: $CurrentPADDING => $PaddingVALUE"
	setMenuItemSpacing $SpacingVALUE $PaddingVALUE
	exit
	;;
-d)
	deleteMenuItemSpacing
	exit
	;;
-r)
	readMenuItemSpacing all
	exit
	;;
-h|*)
	echo "Usage: $(basename $0) [ -h -s SPACING PADDING -d -r ]"
	exit 0
	;;
esac
