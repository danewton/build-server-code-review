#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ "$TYPE" == "pom" ]; then
 exit 0
fi

if [ $(grep -c 'ConsoleAppender' $(find src/main -type f | egrep '.*log.*(\.xml|\.properties)')) -ne 0 ]; then
  echo "Please remove the ConsoleAppender declaration from the java source directory (src/main)."
  grep 'ConsoleAppender' $(find src/main -type f | egrep '.*log.*(\.xml|\.properties)')
  exit 1
fi

