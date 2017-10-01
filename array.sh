#!/bin/bash
# 
#  array.sh
#  Demonstarate a bash array
#
#  Created by Jason Moskowitz on 2010-11-18.
# 

# Declare array 
declare -a ARRAY
#Open file for reading to array
exec 10 < bash.txt
let count=0

while read LINE <& 10; do
    ARRAY[$count ] = $LINE
(( count ++ ))
done

echo Number of elements: ${ # ARRAY [ @ ] }

# Echo array content
echo ${ARRAY [ @ ]}
# close file 
exec 10 >& -
