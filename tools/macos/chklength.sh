#! /bin/sh
#
# Print char length integers
#
# 17.feb.23	ykim
# 2.jul.23	ykim - loop [a-z] for tenth number '0'
#

TMPFILE=/tmp/chlenth_$$

trap 'rm -f $TMPFILE; exit' 0 1 2 3

LEN=20
case $1 in
[0-9]*)		LEN=$1 ;;
esac

>$TMPFILE

AZchar=97	# letter 'a'

for i in $(eval echo {1..$LEN})
do
	digit=$(/bin/echo -n $(($i % 10)))
	case $digit in
	0)	printf "\x$(printf %x $AZchar)" >> $TMPFILE; ((AZchar++)) ;;
	*)	/bin/echo -n $digit >> $TMPFILE ;;
	esac
done
echo >> $TMPFILE

vi $TMPFILE
