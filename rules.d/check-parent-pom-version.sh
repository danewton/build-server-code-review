#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

minVersion "parent-pom" "1.0.9"
if [ $? -ne 0 ]; then
 exit 1
fi

