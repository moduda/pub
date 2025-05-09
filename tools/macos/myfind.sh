#! /bin/sh
#
# Run find in my home dir minus the systems dirs
#
# 8.may.25	ykim
#

find ~ -path ~/.Trash -prune -o -path ~/Library -prune -o -name "$1" -print
