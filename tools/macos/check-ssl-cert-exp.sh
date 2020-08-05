#! /bin/sh
#
# echo | openssl s_client -servername www.gmail.com -connect www.gmail.com:443 2>/dev/null | openssl x509 -noout -enddate
# notAfter=Sep  9 11:30:58 2019 GMT
#
# Usage:  $progname [--alert nnn] domain1 domain2 ...
# without --alert args: reports on all domains provided including expiration dates
#
# 18.jun.19	yoon kim
# 21.jun.19	yoon kim - handle expired doms better
#

ALERT=no

case $1 in
--alert)	ALERT=yes
		DAYSLEFT=$2
		case $DAYSLEFT in
		[0-9][0-9]*)	;;
		*)		echo "alert arg must be an integer"; exit 2 ;;
		esac
		shift; shift
		;;
esac

EXITVAL=0
for dom
do
	EXPDATE=$(echo | openssl s_client -servername ${dom} -connect ${dom}:443 2>/dev/null | openssl x509 -noout -enddate | sed -e "s/.*=//")

	case "$(uname -s)" in
	Darwin)
		EXPSEC=$(date -j -f "%b %d %T %Y %Z" "$EXPDATE" +%s)
		;;
	*)
		if $(lsb_release >/dev/null 2>&1)
		then
			EXPSEC=$(date -d "$EXPDATE" +%s)
		else
			echo "Unkonwn OS"
			exit 1
		fi
		;;
	esac

	TOSEC=$(date +%s)
	DAYSTOGO=$(( ($EXPSEC - $TOSEC) / 86400 ))
	case "$DAYSTOGO" in
	[\-0-9]*)	;;
	*)	echo "Error setting DAYSTOGO variable; exiting"; exit 3 ;;
	esac

	case $ALERT in
	yes)
		if [ $DAYSTOGO -lt $DAYSLEFT ]
		then
			if [ $DAYSTOGO -lt 0 ]
			then
				echo "$dom ssl cert !EXPIRED! $(($DAYSTOGO * -1)) days ago"
			else
				[ $DAYSTOGO -lt $DAYSLEFT ] && echo "$dom ssl cert expires less than $DAYSTOGO days"
			fi
			EXITVAL=99
		fi
		;;
	no)
		if [ $DAYSTOGO -lt 0 ]
		then
			echo "$dom ssl cert !EXPIRED! $(($DAYSTOGO * -1)) days ago on: $EXPDATE"
			EXITVAL=99
		else
			echo "$dom has $DAYSTOGO days left until ssl cert expires on: $EXPDATE"
		fi
		;;
	esac
done

exit $EXITVAL
