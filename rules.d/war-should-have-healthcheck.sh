#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ "$TYPE" != "war" ]; then
 exit 0
fi

isPulseModule
if [ $? -ne 1 ]; then
 exit 0
fi

pomHas "healthcheck-servlet"
if [ $? -ne 1 ]; then
 echo "please add the 'healthcheck-servlet' to the pom.xml"
 exit 1
fi

