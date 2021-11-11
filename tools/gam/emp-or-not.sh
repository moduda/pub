#! /bin/bash
#
# Check if the given user ID is an employee or not
#
# Not employee if either string found in the output of gam user info
# 1) Account Suspended: True
# 2) Resource Not Found: userKey - notFound
#
# 12.feb.16	ykim
#

PWD=$(dirname $0)
. $PWD/gam-script-lib.sh

if [ -f $1 ]
then
	LIST=$(cat $1)
else
	LIST=$*
fi

for i in $LIST
do
	RESULT=$(gam whatis $i 2>&1)
	if [ $(echo "$RESULT" | grep -c "is a user alias") -gt 0 ]
	then
		REAL_EMAIL=$(echo "$RESULT" | awk '/User Email:/ { print $NF }')
		echo "$i is an alias to $REAL_EMAIL"
	elif [ $(echo "$RESULT" | grep -c "doesn't seem to exist!") -gt 0 ]
	then
		echo "$i does not exist"
	else
		echo "$RESULT" | grep "$DOMAIN is "
	fi
done
