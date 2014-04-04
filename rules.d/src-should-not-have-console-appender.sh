#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ "$TYPE" == "pom" ]; then
 exit 0
fi

isPulseModule
if [ $? -ne 1 ]; then
 exit 0
fi

if [ "$(grep 'ConsoleAppender' $(find src/main -type f | grep -v '.svn' | egrep '.*log.*(\.xml|\.properties)') | wc -l)" -ne 0 ]; then
  echo "Please remove the ConsoleAppender declaration from the java source directory (src/main), you're more than welcome to have a ConsoleAppender under src/test, or to use one locally that you supply with JVM args (which is preferred anyway, because you would only need to configure it 1 time for your IDE - not per app)."
  grep 'ConsoleAppender' $(find src/main -type f | grep -v '.svn' | egrep '.*log.*(\.xml|\.properties)')
  exit 1
fi

