#! /bin/sh
#
# ssh directly into Opengear ports
#
# 25.nov.20	ykim
#

case $1 in
"")
	read -p "Enter the dst serial port # [1-16]: " SP
	exec $0 $SP
	;;
[0-9]*)
	[ $1 -lt 1 -o $1 -gt 16 ] && echo "Choose between 1 thru 16" && exit 1
	DST_PORT=$(($1 + 3000))
	;;
*)
	echo "Usage: $(basename $0) serial-port#"
	exit
	;;
esac

UNAME=$(whoami)
# Copy the pub key over first as follows:
# $ scp ~/.ssh/dysi-key-opengear.pub root@64.13.170.93:/etc/config/users/$(whoami)/.ssh/authorized_keys
PKEY=~/.ssh/dysi-key-opengear
CMD="ssh -i "$PKEY" -p $DST_PORT $UNAME@64.13.170.93"
echo "Executing: $CMD"
eval "$CMD"
