#! /bin/sh
#
# Wait while ping fails and after the given IP pings for 10 counts, exit
# Useful to run when ISP connection died and waiting to see when it's back up.
#
# 20.nov.21	ykim
#

trap "echo 'Aborting - $(date).'; exit 1" SIGINT 2 3

# Use the default IP 1.1.1.1 if none provided
case $1 in
"")	IPADDR=1.1.1.1 ;;
*)	IPADDR=$1 ;;
esac

MYIP="$(curl -s ifconfig.me)"
echo "$(date)
Testing dst=$IPADDR from $MYIP ($(whois ${MYIP:-"No Ext. IP"} | grep Organization))"
ping -i 3 $IPADDR 2>&1 | awk -v ipaddr=$IPADDR '
BEGIN { cnt=0 }
/bytes from .*icmp_seq=[0-9]* ttl=[0-9]* time=[0-9]*.* ms/ {
	if (cnt < 5) {
		print; cnt++
	} else {
		printf("--- "ipaddr" is UP - "); exit
	}
}'
echo "$(date) ---"

# Popup ack
TIMESTAMP=$(date)
osascript -e 'tell app "System Events" to display dialog "'"$IPADDR - $TIMESTAMP"' is UP"'
