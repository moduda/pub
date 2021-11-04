#! /bin/zsh
#
# Output all groups and their members
#
# 15.jan.2016	ykim
#
. ~/.zshrc

ALLG=$(gam print groups | egrep -v "^\+|Email")

case $1 in
-g)	echo "$ALLG" | fmt -1 | sort; exit ;;
esac

[ -z "$ALLG" ] && echo "Null list of groups" && exit 1

for g in $ALLG
do
	MEMBERS=$(gam info group $g | egrep -v "^\+|Email" | tr '[A-Z]' '[a-z]' |  awk '/owner:|member:|manager:/ {print $2}')
	echo "$g,"$MEMBERS
done
