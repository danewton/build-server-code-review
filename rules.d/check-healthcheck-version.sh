#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ "$TYPE" != "war" ]; then
 exit 0
fi

version "healthcheck" "1.0.9"
if [ $? -ne 0 ]; then
 exit 1
fi


