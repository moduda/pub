#! /bin/sh

case $1 in
"")
	echo "Usage: $(basename $0) filename"
	exit
	;;
esac

FILE="$1"

case $(file $FILE) in
*"openssl enc'd data with salted password"*)
	openssl enc -d -aes-256-cbc -in $FILE -out ${FILE}.decrypt
	;;
*)
	openssl enc -aes-256-cbc -salt -in $FILE -out ${FILE}.enc
	;;
esac

