#! /bin/zsh
#
# Create a brand new group with some attributes set by default
#
# 15.jan.2016	yoon@tentmakers.com
#

. ~/.zshrc

usage () {
	echo "Usage: $(basename $0) group-name"
}

DOM=mz

case $1 in
"")
	usage; exit 1;;
esac

GROUP=$1

echo "% Note: Use English only"
read "gname?% Enter Group's Long-name for $GROUP: "
#read -p "% Enter Group description for $GROUP: " gdesc
gdesc="$gname"
read -k 1 "reply?% Anyone can (public) send email to $GROUP (y/n)? "
echo
case $reply in
[Yy]*)		ext="allow_external_members true" ;;
*)		ext="allow_external_members false" ;;
esac

set -x
gam create group $GROUP name "$gname" description "$gdesc" $ext 2>/dev/null
set +x
if [ $? != 0 ]
then
	echo "Failed to create $GROUP"
	read -k 1 "reply?%% [Recommended to] Continue with group update anyways (y/n)? "
	echo
	case $reply in
	[Yy]*)	;;
	*)	exit 1 ;;
	esac
fi

gam update group $GROUP who_can_view_membership all_in_domain_can_view

echo "% Fetching group info for: $GROUP"
gam info group $GROUP

if [ $? = 0 ]
then
	read -k 1 "reply?%% Add members to this new group: $GROUP (y/n)? "
	echo
	case $reply in
	[Yy]*)	;;
	*)	exit ;;
	esac

	echo "%% Enter members separated by spaces in a line -OR- filename with members: "
	read newmembers
	newmembers=$(echo $newmembers | sed -e "s/,/ /g")
	add-group-member $GROUP $newmembers
fi
