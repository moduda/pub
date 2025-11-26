#! /bin/sh
#
# Wrapper for gam to use against multiple domains
#
# 21.jun.22	ykim
# 30.aug.22	ykim - list out -h domain options
# 25.nov.25	ykim - retrofit for the new gam version's handling of profiles
#

. $HOME/.zshrc
CURRENTPROFILE=$(gam version | tr ',' '\n' | awk '/Section:/ {print $NF}')

trap 'gam select $CURRENTPROFILE save >/dev/null 2>&1; exit' 0 1 2 3

#GAMBIN="$HOME/bin/gam"
GAMCFG="$HOME/.gam/gam.cfg"

while getopts ":d:" arg
do
	case $arg in
	d)
		DOMX=""
		case $OPTARG in
		ki*)	DOMX=ki ;;
		fc*)	DOMX=fc ;;
		*)	echo "Unrecognized domain: $OPTARG"; exit 1 ;;
		esac
		;;
	*)
		DOMOPTIONS=$(grep -E '^\[' $GAMCFG | grep -v DEFAULT | sed -e 's/^\[\(.*\)\]/\1/')
		echo "Usage: $(basename $0) [ -d {"$DOMOPTIONS"} ] args ..."
		exit
		;;
	esac
done

shift $((OPTIND-1))
gam select $DOMX save >/dev/null 2>&1

"$@"
