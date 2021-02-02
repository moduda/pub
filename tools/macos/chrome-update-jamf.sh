#!/bin/sh
#
# Update Chrome browser
#
# Check to see if the local version needs upgrading first before downloading the .dmg
#

dmgfile="googlechrome.dmg"
TMP_DMGFILE="/tmp/${dmgfile}"
volname="Google Chrome"

case $(whoami) in
root)	;;
*)	echo "Must be run as root"; exit 1 ;;
esac

case $(tty) in
/dev/tty*) # output to terminal in an interactive session
	logfile="/dev/tty"
	;;
*)
	logfile="/Library/Logs/GoogleChromeInstallScript.log"
	;;
esac

case $1 in
-h)
	echo "Usage: $(basename $0) [ -h -f ]"; exit ;;
esac

do_cleanup()
{
	if [ $(/bin/df | /usr/bin/grep -c "${volname}") -gt 0 ]
	then
		/bin/echo "$(date): Unmounting installer disk image ($volname)." >> ${logfile}
		/usr/bin/hdiutil detach $(/bin/df | /usr/bin/grep "${volname}" | awk '{print $1}') -quiet
		/bin/sleep 10
	fi

	if [ -f ${TMP_DMGFILE} ]
	then
		/bin/echo "$(date): Deleting disk image." >> ${logfile}
		/bin/rm "${TMP_DMGFILE}"
	fi
}

get_latest_version()
{
	RESULT=$(
cat << EOFCAT | python
# Returns:
#	True = if latest Chrome version is already installed locally
#	False = otherwise
#
# Source: https://lew.im/2017/03/auto-update-chrome/
#

import json
import urllib2
import os.path
import plistlib

#
# http://omahaproxy.appspot.com/about returns:
# > This application is supported by the Chromium team, as a tool to track current releases and release history.
url = 'http://omahaproxy.appspot.com/all.json'
resp = urllib2.urlopen(url)

data = json.loads(resp.read())

for each in data:
    if each.get("os") == "mac":
        versions = each.get("versions")
        for version in versions:
            if version.get("channel") == "stable":
                latest = (version.get("current_version"))

print latest
EOFCAT
)
	echo $RESULT
}

case $1 in
-f)     FORCE_INSTALL=yes ;;
*)      FORCE_INSTALL=no ;;
esac

url='https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg'

/bin/echo "--" >> ${logfile}

# Check versions
LATEST_VERSION=$(get_latest_version)
INSTALLED_VERSION=$("/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --version | awk '{ print $NF }')

case $FORCE_INSTALL in
yes)
	;;
*)
	if [ "$LATEST_VERSION" = "$INSTALLED_VERSION" ]
	then
		echo "Latest version ($INSTALLED_VERSION) already installed. Exiting now." >> ${logfile}
		do_cleanup
		exit 0
	fi
	;;
esac

/bin/echo "$(date): Installing version ($LATEST_VERSION) ..." >> ${logfile}

# Download new version
/bin/echo "$(date): Downloading latest version." >> ${logfile}
/usr/bin/curl -s -o "${TMP_DMGFILE}" "${url}"

[ ! -r "${TMP_DMGFILE}" ] && echo "Download failed. Aborting!" && do_cleanup && exit 1

/bin/echo "$(date): Mounting installer disk image." >> ${logfile}
/usr/bin/hdiutil attach ${TMP_DMGFILE} -nobrowse -quiet

ditto -rsrc "/Volumes/${volname}/Google Chrome.app" "/Applications/Google Chrome.app"
/bin/sleep 10

do_cleanup

exit 0
