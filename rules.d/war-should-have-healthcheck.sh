#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ "$TYPE" != "war" ]; then
 exit 0
fi

if [ $(grep -c 'health-check' pom.xml) -eq 0 ]; then
 echo "please add the healthcheck jar to the war's pom.xml"
 exit 1
fi

