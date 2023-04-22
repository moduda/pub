#! /bin/sh
#
# Just list out the email addresses from the input stream
#
# 30.jun.22	ykim
#

case $1 in
"")	FILENAME="" ;;
*)	FILENAME="$*" ;;
esac

RESULT=$(cat $FILENAME | sed -e "s/,/ /g" | fmt -1 | grep '\@' | sed -e "s/.*<//" -e "s/>.*//")
echo "** Emails found:"
echo "$RESULT"
