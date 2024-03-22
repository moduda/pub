#! /bin/sh
#
# Get basic network settings to debug issues
#
# 25.feb.19	ykim@dynamicsignal.com
# 4.sep.22	ykim - Added hostnames
#

AD_NAME=influentials.local

case $1 in
-csv)	CSV=yes ;;
*)	CSV=no
	/bin/echo -n "Gathering info ."
	;;
esac

MYUSERNAME=$(id -un)
MYFULLNAME=$(id -F)
SERIALNUM=$(ioreg -l | grep "IOPlatformSerialNumber" | awk '{print $NF}' | sed -e "s/\"//g")
/bin/echo -n "."
AD_NAME=$(dsconfigad -show | awk '/Active Directory Domain/{print $NF}')
[ -n "$AD_NAME" ] && AD_SERVER_IP=$(ping -c 1 $AD_NAME | head -1 | awk '{print $2, $3}' | sed -e "s/://g")
/bin/echo -n "."
#GATEWAY=$(traceroute 1.1.1.1 2>/dev/null | head -3 | awk '/ 1 / { print $2, $3 }')
#[ -n "$GATEWAY" ] && GATEWAY=$(netstat -rn | grep default | awk '$2 ~ /^[0-9]/ { print $2 }')
GATEWAY=$(netstat -rn | grep default | awk '$2 ~ /^[0-9]/ { print $2 }')
/bin/echo -n "."
MY_SUBNET=$(for n in $GATEWAY; do echo "$n" | sed -e "s/\([0-9]*\.[0-9]*\.[0-9]*\)\..*/\1/"; done)
/bin/echo -n "."
#[ -n "$MY_SUBNET" ] && MY_IP=$(ifconfig | grep "$MY_SUBNET" | awk '{ print $2 }')
[ -n "$MY_SUBNET" ] && MY_IP=$(for n in $MY_SUBNET; do ifconfig | grep "$n" | awk '{ print $2 }'; done | sort -u)
/bin/echo -n "."
#[ -n "$MY_SUBNET" ] && MY_MEDIA=$(ifconfig | grep -A2 "$MY_SUBNET" | tail -1 | sed -e "s/.*: //")
[ -n "$MY_SUBNET" ] && MY_MEDIA=$(for n in $(ifconfig -l); do ifconfig $n | awk '/inet [0-9]/ { print arg"="$2 }' arg=$n; done)
MYHOSTNAMES=$(
        echo "HostName: $(scutil --get HostName)"
        echo "LocalHostName: $(scutil --get LocalHostName)"
        echo "ComputerName: $(scutil --get ComputerName)"
)
MYISPIP=$(curl -s ifconfig.me)
# deprecated # SSID=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport --getinfo | sed -n 's/^ *SSID: //p')
WIFI_PORT=$(networksetup -listallhardwareports | grep -A1 -i "wi-fi" | tail -1 | awk '{ print $NF }')
[ -n "$WIFI_PORT" ] && SSID=$(networksetup -getairportnetwork $WIFI_PORT | awk '{ print $NF }')
/bin/echo ". done"

case $CSV in
yes)
	cat <<- EOF
		MYUSERNAME,MYFULLNAME,SERIALNUM,SSID,AD_NAME,AD_SERVER_IP,MY_IP,GATEWAY,MY_MEDIA
		${MYUSERNAME},${MYFULLNAME},${SERIALNUM},${SSID},${AD_NAME},${AD_SERVER_IP},${MY_IP},${GATEWAY},${MY_MEDIA}
	EOF
	;;
*)
	cat <<- EOF
		USER: $MYUSERNAME
		FULLNAME: $MYFULLNAME
		S/N: $SERIALNUM
		$MYHOSTNAMES
		$(sw_vers)
		WIFI PORT: $WIFI_PORT
		SSID: $SSID
		AD Name: ${AD_NAME:-"Not Joined"}
		AD Server IP: $AD_SERVER_IP
		MY IP: $(echo $MY_IP | fmt -200)
		MY Gateway: $(echo $GATEWAY | fmt -200)
		MY Media: $(echo $MY_MEDIA | fmt -200)
		MY ISP IP: $MYISPIP ($(host $MYISPIP | awk '{print $NF}'))
	EOF
	;;
esac
