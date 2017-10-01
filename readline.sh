#!/bin/sh
file="print-servers"

cat $FILE |
while read PRINTSERVER
do
echo $PRINTSERVER
sleep 2
done
