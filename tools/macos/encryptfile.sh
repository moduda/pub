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
	openssl enc -d -aes-256-cbc -pbkdf2 -iter 100000 -in $FILE -out ${FILE}.decrypt
    chmod 600 ${FILE}.decrypt
	;;
*)
    openssl enc -aes-256-cbc -pbkdf2 -iter 100000 -salt -in $FILE -out ${FILE}.enc
    chmod 600 ${FILE}.enc
	;;
esac

