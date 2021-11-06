#! /bin/bash
#
# Library for the scripts
#
# 15.jan.2016	ykim
#

. ~/.bash_profile
#. ~/.zshrc

DOMAIN="default.com"

gen_usage () {
	echo "Usage: $(basename $0) [dom1|dom2|dom3] $*"
}
