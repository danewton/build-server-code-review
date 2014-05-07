#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ "$TYPE" == "pom" ]; then
 exit 0
fi;

GRPID=$(getPomGroupId)
if [ $(echo "$GRPID" | grep -c "com.suddenlink") -ne 1 ]; then
 echo "Please change your pom's groupId to start with 'com.suddenlink'.  This assertion is only looking within the top 10 lines of your pom.xml."
 exit 1
fi
