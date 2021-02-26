#! /bin/sh
#
# http://uname:pw@dynupdate.no-ip.com/nic/update?hostname=mytest.example.com&myip=192.0.2.25
# uname:pw = base64 encoded string
#
# HTTP GET header:
# GET /nic/update?hostname=mytest.example.com&myip=192.0.2.25 HTTP/1.1
# Host: dynupdate.no-ip.com
# Authorization: Basic base64-encoded-auth-string
# User-Agent: Company DeviceName-Model/FirmwareVersionNumber maintainer-contact@example.com
#

UPFILE=~/tmp/upfile.txt
UPFILE_MODE=$(stat -f %A $UPFILE)
#UPW=$(echo $(grep -v "^#" $UPFILE | grep UPW= | sed -e "s/UPW=//" -e "s/^ *//") | base64 -i -) 
UPW=$(grep -v "^#" $UPFILE | grep UPW= | sed -e "s/UPW=//" -e "s/^ *//")
MYHOSTNAME=$(grep -v "^#" $UPFILE | grep MYHOSTNAME= | sed -e "s/MYHOSTNAME=//" -e "s/^ *//")
MYCURRENTIP=$(curl -s ifconfig.me)
MYDNSIP=$(host "$MYHOSTNAME" | awk '{ print $NF }')

# Make sure UPFILE has private mode
case $UPFILE_MODE in
*00)	;;
*)	echo "The UPFILE has a wrong mode."; exit 1 ;;
esac

[ -z "$MYDNSIP" -o -z "$MYCURRENTIP" ] && echo "Failed to get IP addresses" && exit 2

if [ "$MYDNSIP" = "$MYCURRENTIP" ]
then
	#NEWIP=73.170.105.60
	NEWIP=192.160.100.10
else
	NEWIP=$MYCURRENTIP
fi

curl "https://${UPW}@dynupdate.no-ip.com/nic/update?hostname=${MYHOSTNAME}&myip=${NEWIP}"
