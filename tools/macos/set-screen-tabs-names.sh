#! /bin/bash
#
# 19.jun.22	ykim
#

case $1 in
"")
	echo "Usage: $(basename $0) new tab name"
	exit
	;;
esac

echo -en "\033]1; $* \007"
