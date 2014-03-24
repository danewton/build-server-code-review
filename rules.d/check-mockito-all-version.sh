#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

minVersion "mockito-all" "1.9.0"
if [ $? -ne 0 ]; then
 exit 1
fi


