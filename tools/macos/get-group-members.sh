#! /bin/bash
#
# Print members of google groups
#
# 26.apr.22	ykim
# 16.may.22	ykim - Recursively get all nested sub group members
#

. ~/.bash_profile

get_g_members()
{
	for gg
	do
		echo "------[ $gg ]------"
		MEMBERS=$(gam whatis $gg 2>/dev/null | sed -n "/^Members:$/,\$p")
		echo "$MEMBERS"
		SUBGROUPS=$(echo "$MEMBERS" | awk '$NF == "(group)" { print $2 }')

		case $SUBGROUPS in
		"")	;;
		*)	get_g_members $SUBGROUPS ;;
		esac
	done
}

for g
do
	get_g_members $g
done
