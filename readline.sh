#!/bin/sh
#
# Demonstrates reading lines from file
#

FILE="foo"

cat $FILE |
while read LINE
  do
    echo $LINE
    sleep 1
  done
