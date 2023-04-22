#! /bin/sh
#
# Loop through speedtest every N minutes
# Useful to run it in a terminal window to see the ISP throughput
#
# 10.apr.20	ykim
#

THIS_SCRIPT="$0"
WAIT_MINUTES=5

LOGFILE="$HOME/tmp/$(basename $0).log"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

printout()
{
	echo "$*" 2>&1 | tee -a "$LOGFILE"
}

if which speedtest >/dev/null 2>&1
then
	printout "** Starting speedtest loop.  Ctrl-\ will start a new test in between $WAIT_MINUTES min cycle"
else
	printout "Failed to find 'speedtest' command.  Instructions to install is at, https://www.speedtest.net/apps/cli"
	exit 1
fi

trap 'printout ".....rerun...... // DEBUG_DUL: TOTAL($TOTAL_DOWN/$TOTAL_UP/$TOTAL_LATENCY)"' QUIT

## SAMPLE speedtest outout:
TEST_RESULT="Mon Mar 23 15:03:01 PDT 2020
Retrieving speedtest.net configuration...
Testing from Comcast Cable (24.6.12.202)...
Retrieving speedtest.net server list...
Selecting best server based on ping...
Hosted by KamaTera INC (Santa Clara, CA) [16.26 km]: 38.604 ms
Testing download speed................................................................................
Download: 133.57 Mbit/s
Testing upload speed................................................................................................
Upload: 6.94 Mbit/s"
## END OF TEST RESULT TEXT

calc()  {
	EQU=$(echo "$*" | sed -e "s/ //g")
	echo "scale=2;${EQU}" | bc
}

COUNT=0
AVG_DOWN=0
AVG_UP=0
AVG_LATENCY=0
TOTAL_DOWN=0
TOTAL_UP=0
TOTAL_LATENCY=0

# Continue from last run unless -r flag is set
case $1 in
-r)	;;
*)
	eval $(egrep "^SHORTFORM;" $LOGFILE | tail -1 | awk -F\; '{printf("COUNT=%s; AVG_DOWN=%s; AVG_UP=%s; AVG_LATENCY=%s", $2, $(NF-2), $(NF-1), $NF)}')
	;;
esac

while :
do
	printout "${PURPLE}$(date)${NC}"
	RESULT=$(speedtest)
	## RESULT="$TEST_RESULT"
	echo "${RESULT}" | 
		awk '/^Download:/ {print "\033[0;32m"$0"\033[0m"} /^Upload:/ {print "\033[0;33m"$0"\033[0m"} /^Hosted by/ {print "\033[0;36m"$0"\033[0m"}' |
		tee -a $LOGFILE
	DOWN_NOW=$(echo "${RESULT}" | awk '/^Download:/ {print $2 + 0.5}')
	UP_NOW=$(echo "${RESULT}" | awk '/^Upload:/ {print $2 + 0.5}')
	LATENCY_NOW=$(echo "${RESULT}" | awk '/^Hosted by/ {print $(NF-1) + 0.5}')
	[ -z "$DOWN_NOW" -a -z "$UP_NOW" -a -z "$LATENCY_NOW" ] && printout "Restarting this script: NOW = NIL." &&  sleep 10 && exec "${THIS_SCRIPT}" -r
	((COUNT++))
	TOTAL_DOWN=$(calc ${TOTAL_DOWN} + ${DOWN_NOW})
	TOTAL_UP=$(calc ${TOTAL_UP} + ${UP_NOW})
	TOTAL_LATENCY=$(calc ${TOTAL_LATENCY} + ${LATENCY_NOW})
	[ -z "$TOTAL_DOWN" -o -z "$TOTAL_UP" -o -z "$TOTAL_LATENCY" ] && printout "Restarting this script: TOTALS = NIL DUL($TOTAL_DOWN/$TOTAL_UP/$TOTAL_LATENCY)." &&  sleep 10 && exec "${THIS_SCRIPT}" -r
	AVG_DOWN=$(calc $TOTAL_DOWN / $COUNT )
	AVG_UP=$(calc $TOTAL_UP / $COUNT)
	AVG_LATENCY=$(calc $TOTAL_LATENCY / $COUNT )
	printout "SHORTFORM;$COUNT;$(date '+%F %T');$DOWN_NOW;$UP_NOW;$LATENCY_NOW"
	printout "C=$COUNT AVG ${GREEN}D: $AVG_DOWN${NC} / ${YELLOW}U: $AVG_UP${NC} / ${CYAN}L: $AVG_LATENCY${NC}"
	printout "${RED}+++++++++++++++++++++++++++ [$WAIT_MINUTES min wait] Ctrl-\\ = re-test; Ctrl-C = quit${NC}"
	sleep $(( $WAIT_MINUTES * 60 ))
done
