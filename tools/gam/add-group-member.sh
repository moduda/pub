#! /bin/sh
#
# Add new member(s) to an existing group
#
# 15.jan.2016	ykim
#

usage() {
	echo "Usage: $(basename $0) [owner|manager|member] group-name user-name"
}

case $1 in
owner|manager|member)	OM=$1; shift ;;
*)		OM=member ;;
esac

g=$1

if [ -f $2 ]
then
	for u in $(cat $2 | sed -e "s/,/ /g")
	do
		echo "++ ./gam $C update group $g add $OM $u"
		./gam $C update group $g add $OM $u
	done
else
	shift
	for m in $*
	do
		echo "++ ./gam $C update group $g add $OM $m"
		./gam $C update group $g add $OM $m
	done
fi
