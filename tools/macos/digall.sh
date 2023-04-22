#! /bin/sh
#

for h
do
	for d in $(grep ^nameserver /etc/resolv.conf | head -1 | awk '{print $2}') 1.1.1.1 8.8.8.8 9.9.9.9
	do
		RESULT=$(host $h $d | grep "has address")
		case $? in
		0)	echo "$d => $RESULT" ;;
		*)	echo "$d => FAILED" ;;
		esac
	done
done
