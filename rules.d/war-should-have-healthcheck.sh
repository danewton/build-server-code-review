#!/bin/bash

rtn=0
msg=/tmp/msg$$

echo -n "testing healthcheck ... "
if [ $(grep -c 'healthcheck' pom.xml) -ne 0 ]; then
 echo "SUCCESS"
else
 rtn=1
 echo "FAILED"
 echo "please add the healthcheck jar to the pom.xml" >> $msg
fi

# if there's a message, echo with a few spaces in front of each line, then remove
if [ -f "$msg" ]; then
  sed 's/^/  /g' $msg
  rm $msg
fi

exit $rtn

