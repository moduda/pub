#! /bin/sh
#
# 25.jul.19		ykim
#

case $1 in
"")	echo "Usage: $(basename) \"new title\""; exit 1 ;;
esac

echo "\033]1;${1}\033\\"
