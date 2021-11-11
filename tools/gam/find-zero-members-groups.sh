#! /bin/bash
#
# Output all groups and their members
#
# 15.jan.2016	ykim
#

PWD=$(dirname $0)
. $PWD/gam-script-lib.sh

ALLG=$(gam print groups | egrep -v "^\+|Email")

case $1 in
-g)	echo "$ALLG" | fmt -1 | sort; exit ;;
esac

[ -z "$ALLG" ] && echo "Null list of groups" && exit 1

for g in $ALLG
do
	MEMBERS=$(gam whatis $g | awk '$1 == "directMembersCount:" { print $2 }')
	echo "$g, $MEMBERS"
done
