#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ "$TYPE" != "war" ]; then
 exit 0
fi

if [ ! -f "$WEBXML" ]; then
  echo "please add a web.xml to this war project."
  return 1
fi


