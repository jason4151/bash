#!/bin/bash
RANGE=100
number=$RANDOM
let "number %= $RANGE"
echo "Random number less than $RANGE  ---  $number"
