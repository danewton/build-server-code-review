#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

MINVER="1.0.9"
PPVER="$(version "parent-pom")"
if [ "$PPVER" != "$MINVER" ]; then
 echo "please update your parent-pom from '"$PPVER"' to version $MINVER"
 exit 1
fi


