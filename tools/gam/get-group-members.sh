#! /bin/bash
#
# Print members of given group(s)
#
# 15.jan.2016	ykim
#

case $1 in
-v)	VERBOSE=yes; shift ;;
*)	VERBOSE=no ;;
esac

case $1 in
?|"")	echo "Usage: $(basename $0) [-v] group-name user-name"; exit 1 ;;
esac

case $VERBOSE in
yes)
	set -x
	./gam info group $1
	;;
*)
	set -x
	./gam info group $1 | awk '/(manager|member|owner):|Total/ { print "  "$1, $2; next }'
	;;
esac
