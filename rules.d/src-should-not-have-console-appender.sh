#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ "$TYPE" == "pom" ]; then
 exit 0
fi

if [ "$(grep 'ConsoleAppender' $(find src/main -type f | grep -v '.svn' | egrep '.*log.*(\.xml|\.properties)') | wc -l)" -ne 0 ]; then
  echo "Please remove the ConsoleAppender declaration from the java source directory (src/main)."
  grep 'ConsoleAppender' $(find src/main -type f | grep -v '.svn' | egrep '.*log.*(\.xml|\.properties)')
  exit 1
fi

