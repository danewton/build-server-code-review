#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

rtn=0

minVersion "slf4j-api" "1.7.6"
if [ $? -ne 0 ]; then
 rtn=1
fi

minVersion "log4j-over-slf4j" "1.7.6"
if [ $? -ne 0 ]; then
 rtn=1
fi

exit $rtn

