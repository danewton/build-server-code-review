#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

minVersion "logback-classic" "1.1.1"
if [ $? -ne 0 ]; then
 exit 1
fi


