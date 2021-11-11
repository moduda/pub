#! /bin/bash
#
# Remove member(s) from an existing group
#
# 15.jan.2016	ykim
#

PWD=$(dirname $0)
. $PWD/gam-script-lib.sh

usage() {
	echo "Usage: $(basename $0) [owner|member] group-name user-name"
}

case $1 in
owner|member)	OM=$1; shift ;;
*)		OM=member ;;
esac

g=$1

if [ -f $2 ]
then
	for u in $(cat $2)
	do
		echo "++ gam update group $g remove $OM $u"
		gam update group $g remove $OM $u
	done
else
	shift
	for m in $*
	do
		echo "++ gam update group $g remove $OM $m"
		gam update group $g remove $OM $m
	done
fi
