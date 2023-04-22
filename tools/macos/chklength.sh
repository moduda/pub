#! /bin/sh
#
# Print char length integers
#
# 17.feb.23	ykim
#

TMPFILE=/tmp/chlenth_$$

trap 'rm -f $TMPFILE; exit' 0 1 2 3

LEN=20
case $1 in
[0-9]*)		LEN=$1 ;;
esac

>$TMPFILE
for i in $(eval echo {1..$LEN})
do
	/bin/echo -n $(($i % 10)) >> $TMPFILE
done
echo >> $TMPFILE

vi $TMPFILE
