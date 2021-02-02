#!/bin/bash
#
# This script runs within a policy is scoped to devices listed as 'Old' in the Extension Attribute.
#
# 10/25/2020
# 1/11/2021 - Adding updated timestamp.
# 1/20/2021 - Check versions as non-root user first.
#

check_root()
{
	case $(whoami) in
	root)	;;
	*)	echo "Must be run as root"; exit 1 ;;
	esac
}

case $1 in
-h)
	echo "Usage: $(basename $0) [ -h -f ]"; exit ;;
esac

case $1 in
-f)	FORCE_INSTALL=yes ;;
*)	FORCE_INSTALL=no ;;
esac

MY_CUR_VERS_STR="_MY_CURRENT_VERSION_"
MY_CUR_VERS_TIMESTAMP="_MY_UPDATE_TIMESTAMP_"
OSvers_URL=$( sw_vers -productVersion | sed 's/[.]/_/g' )
userAgent="Mozilla/5.0 (Macintosh; Intel Mac OS X ${OSvers_URL}) AppleWebKit/535.6.2 (KHTML, like Gecko) Version/5.2 Safari/535.6.2"
# Get the latest version of Reader available from Zoom page.
latestvers=$(/usr/bin/curl -s -A "$userAgent" https://zoom.us/download | grep 'ZoomInstallerIT.pkg' | awk -F'/' '{print $3}')
PLISTFILE="/Library/Preferences/us.zoom.config.plist"
# plist file temp location
# this gets written to the final dst: /Library/Preferences/us.zoom.config.plist
TMP_PLISTFILE="/var/tmp/us.zoom.config.plist"
# PKG location
url="https://zoom.us/client/${latestvers}/ZoomInstallerIT.pkg"
# PKG path
pkg_path="/var/tmp/ZoomInstallerIT.pkg"

case $FORCE_INSTALL in
yes)
	check_root
	echo "Re-installing the latest version ($latestvers)"
	;;
*)
	# Check to see if latest version already installed
	MY_CUR_VERS=$(grep "$MY_CUR_VERS_STR" $PLISTFILE | sed -e "s/-->//" | awk '{ print $NF }')
	MY_LAST_UPDATE=$(grep "$MY_CUR_VERS_TIMESTAMP" $PLISTFILE | sed -e "s/-->//" -e "s/.*${MY_CUR_VERS_TIMESTAMP}: //" | awk '{ print }')
	[ -z "$MY_LAST_UPDATE" ] && MY_LAST_UPDATE=$(stat -x $PLISTFILE | grep Modify: | sed -e "s/Modify: //")
	[ "$MY_CUR_VERS" = "$latestvers" ] && echo "Latest version ($latestvers) already installed on ${MY_LAST_UPDATE}." && exit 10
	check_root
	echo "Upgrading current ($MY_CUR_VERS) to latest version: ${latestvers}"
	;;
esac

# Construct the plist file for preferences
cat << EOFCAT  > "$TMP_PLISTFILE"
<!-- $MY_CUR_VERS_STR: $latestvers -->
<!-- $MY_CUR_VERS_TIMESTAMP: $(date '+%F %T %Z')-->
<?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
      <key>nogoogle</key>
      <true/>
      <key>nofacebook</key>
      <true/>
      <key>disableloginwithemail</key>
      <false/>
      <key>LastLoginType</key>
      <true/>
      <key>ZAutoUpdate</key>
      <true/>
      <key>ZAutoJoinVoip</key>
      <true/>
      <key>ZAutoSSOLogin</key>
      <false/>
      <key>ZSSOHost</key>
      <string>mydom.zoom.us</string>
      <key>ZRemoteControlAllApp</key>
      <true/>
      </dict>
      </plist>
EOFCAT

case $? in
0)	;;
*)	echo "Failed to update plist: $TMP_PLISTFILE; but contiuing on" ;;
esac

/usr/bin/curl --silent -L -o "$pkg_path" "${url}"

case $? in
0)	;;
*)	echo "Failed to fetch $pkg_path @ $url; aborting"; exit 2 ;;
esac

/usr/sbin/installer -pkg "$pkg_path" -target /

rm -f "$pkg_path" "$TMP_PLISTFILE"
