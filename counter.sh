#!/bin/bash
#
# counter.sh
# Demonstrates a bash counter
#
# Created by Jason Moskowitz on 2010-11-18
#

COUNT=0

# Bash until loop
until [ $COUNT -gt 5 ]; do
        echo Value of count is: $COUNT
        let COUNT=COUNT+1
done

