#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ $(grep -c 'parent-pom' pom.xml) -eq 0 ]; then
 echo "please add the parent-pom to the pom.xml"
 exit 1
fi

