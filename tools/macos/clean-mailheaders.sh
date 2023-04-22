#! /bin/sh
#
# Input: the raw mail headers
# Output: show just the significant lines for debugging
#
# 13.aug.20	ykim
#

GETXHEADERS=no

case $1 in
-h)	echo "Usage: $(basename $0) [ -h ] < file"; exit;;
-x)	GETXHEADERS=yes ;;
esac

RAW_HEADERS=$(cat)

echo "----------- OUTPUT -----------"
echo "$RAW_HEADERS" | awk -v xhdr=$GETXHEADERS '
BEGIN {
	cont=0
	if (xhdr == "yes")  {
		GREPSTR="^(To:|From:|Reply-To:|Received[:-]|Date:|Subject:|Return-Path:|Message-ID:|Authentication-Results:|X-.*: )"
	} else  {
		GREPSTR="^(To:|From:|Reply-To:|Received[:-]|Date:|Subject:|Return-Path:|Message-ID:|Authentication-Results:)"
	}
}
{
	if (cont == 1 && $1 !~ /:$/)  {
		print "   ", $0
	}  else  {
		cont=0
	}
}
$0 ~ GREPSTR  {
	cont=1
	print
}'
