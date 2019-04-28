#!/bin/bash
#
# Demonstrates a Bash number range
#

RANGE=100
number=$RANDOM
let "number %= $RANGE"
echo "Random number less than $RANGE  ---  $number"
