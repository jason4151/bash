#!/bin/bash
#
# Demonstrates a Bash counter
#

COUNT=0

# Bash until loop
until [ $COUNT -gt 5 ]; do
  echo Value of count is: $COUNT
  let COUNT=COUNT+1
done

