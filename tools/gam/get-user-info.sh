#! /bin/zsh
#
# Display key components of user's properties
#
# 15.jan.2016	ykim
#
. ~/.zshrc

case $1 in
-v)	VERBOSE=yes; shift ;;
*)	VERBOSE=no ;;
esac

case $1 in
?|"")	echo "Usage: $(basename $0) [-v] user-name"; exit 1 ;;
*)	C= ;;
esac

case $VERBOSE in
yes)
	gam $C info user $1
	;;
*)
	gam $C info user $1 2>/dev/null | awk '/(User|title|department|Name):|Total/ { print; next }'
	;;
esac
