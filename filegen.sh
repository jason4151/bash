fileDir=/programs/stresstest
count=0
# bash until loop
until [ $count -gt $1 ]; do
number=$RANDOM
        echo "Generating Random File: $count"
dd if=/dev/zero of=$fileDir/testfile-$number bs=100000000 count=1

let count=count+1
done
