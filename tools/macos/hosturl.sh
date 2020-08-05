#! /bin/sh
#
# 4.aug.20		ykim
#

[ -z "$1" ] && echo "Usage: $(basename $0) URL" && exit 1

while [ $# -gt 1 ]
do
	FLAGS="$FLAGS $1"
	shift
done

HOST=$(echo "$1" | sed -e "s;http.*//;;" -e "s;/.*;;")

echo "+ looking up: $FLAGS $HOST"
host $FLAGS "$HOST"
