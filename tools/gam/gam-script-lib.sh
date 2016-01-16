#! /bin/bash
#
# Library for the scripts
#
# 15.jan.2016	yoon@tentmakers.com
#

gen_usage () {
	echo "Usage: $(basename $0) [dom1|dom2|dom3] $*"
}

get_env() {
	case $1 in
	"")	return 1 ;;
	*)	C= ;;
	esac
	echo $C $*
}
