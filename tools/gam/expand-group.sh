#! /bin/bash
#
# Expand groups members recursing down the sub-groups
#
# 15.jan.2016	ykim
#

. ./gam-script-lib.sh

case $1 in
?|"")	echo "Usage: $(basename $0) group-name"; exit 1 ;;
esac

GNAME=$1

members=$(gam info group $GNAME |
	awk '/(manager|member|owner):/ {
		if ($NF ~ /(user)/) {
			userlist = sprintf("%s %s", userlist, $2)
		} else if ($NF ~ /(group)/) {
			grouplist = sprintf("%s %s", grouplist, $2)
		}
	}
	END {
		printf("ULIST=\"%s\"; GLIST=\"%s\"\n", userlist, grouplist)
	}' | sed -e "s/@$DOMAIN//g"
)

eval $members

echo "${inTAB}$GNAME: $ULIST"

if [ -n "$GLIST" ]
then
	export inTAB="$inTAB    "
	for g in $GLIST
	do
		$0 $g
	done
fi
