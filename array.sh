#!/bin/bash
# 
#  Demonstarates a bash array
#

# Declare array 
declare -a ARRAY

# Open file for reading to array
exec 10 < bash.txt
let count=0

while read LINE <& 10; do
  ARRAY[$count ] = $LINE
  (( count ++ ))
done

echo Number of elements: ${ # ARRAY [ @ ] }

# Echo array content
echo ${ARRAY [ @ ]}

# Close file 
exec 10 >& -
