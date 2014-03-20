#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ $(grep -c 'parent-pom' pom.xml) -eq 0 ]; then
 echo "please add the healthcheck jar to the pom.xml"
 exit 1
fi

