#!/usr/bin/env bash

if [ -z "$1" ]; then echo "usage: $0 <file_url>"; exit 0; fi

url=$1
file=$(mktemp)
ext=${url##*.}

cleanup() {
	rm $file 2>/dev/null || true
	exit 0
}

trap cleanup INT TERM EXIT
sum_prev='x'

while true
do	
	wget -O $file -q -- $url
	sum=$(md5sum $file| cut -f1 -d' ')
	if [ "_$sum" != "_$sum_prev" ]; then
		sum_prev=$sum
		newfile=$(date +%s).$ext
		filesize=$(wc -c $file| cut -f1 -d' ')
	
		cp $file ./$newfile
		echo $newfile $filesize bytes, md5sum:$sum
	else
		echo -n .
	fi
done	
