#!/bin/sh

while : # Loop forever
do
cat << EOF

1. Regression Tests
2. Smoke Tests
3. Quit

EOF

echo -n " Your choice? : "
read choice

case $choice in
1) f_Reg ;;
2) f_Smoke ;;
3) exit ;;
*) echo "\"$choice\" is not valid "; sleep 2 ;;
esac
done