#!/bin/bash
#
# Demonstrates random file generation
#

DIR=/tmp
COUNT=0

# Until loop
until [ $COUNT -gt $1 ]; do
  NUMBER=$RANDOM
  echo "Generating Random File: $COUNT"
  dd if=/dev/zero of=$DIR/file_$NUMBER bs=100000000 count=1
  let COUNT=COUNT+1
done
