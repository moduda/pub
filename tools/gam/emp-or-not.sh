#! /bin/bash
#
# Check if the given user ID is an employee or not
#
# Not employee if either string found in the output of gam user info
# 1) Account Suspended: True
# 2) Resource Not Found: userKey - notFound
#
# 12.feb.16	yoon.kim
#

KEYSTR="Resource Not Found: userKey - notFound|Account Suspended:.*True"

if [ -f $1 ]
then
	LIST=$(cat $1)
else
	LIST=$*
fi

for i in $LIST
do
	if [ $(./gam info user $i 2>&1 | egrep -c "$KEYSTR") -gt 0 ]
	then
		echo "NOT EMP or Gapps User: $i"
	fi
done
