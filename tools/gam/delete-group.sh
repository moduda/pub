#! /bin/bash
#
# Delete an existing group
#
# 15.jan.2016	ykim
#

PWD=$(dirname $0)
. $PWD/gam-script-lib.sh

usage () {
	echo "Usage: $(basename $0) group-name"
}

case $1 in
"")
	usage
	exit 11
	;;
esac

echo -n "This removes the whole DL group: $1
Do you want to proceed (y/n)? "
read reply
case $reply in
[Yy]*)	;;
*)	echo "Aborting."; exit ;;
esac

gam delete group $1
if [ $? != 0 ]
then
	echo "Failed to delete group: $1"
fi
