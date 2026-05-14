#! /bin/sh
#
# Run find in my home dir minus the systems dirs
#
# 8.may.25	ykim
#

case $1 in
-f*)
    FLAGS="$2"
    shift 2
    ;;
esac

find ~ -path ~/.Trash -prune -o -path ~/Library -prune -o $FLAGS -name "$1" -print
