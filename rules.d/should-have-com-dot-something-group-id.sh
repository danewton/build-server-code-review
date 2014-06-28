#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ "$TYPE" == "pom" ]; then
 exit 0
fi;

GRPID=$(getPomGroupId)
if [ $(echo "$GRPID" | grep -Ec "(com|net)\.\w*") -ne 1 ]; then
 echo "Please change your pom's groupId to start with 'com.something' or 'net.something'."
 exit 1
fi
