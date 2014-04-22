#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ "$TYPE" == "pom" ]; then
 exit 0
fi

if [ $(grep -R 'new Exception()' $SRCDIR | grep -v '.svn' | wc -l) -ne 0 ]; then
  echo "Please replace the 'new Exception()' calls with something more meaningful.  If this is being thrown as a new Exception with no message from a catch block, then that could likely lead to the full stack not getting logged.  If you're creating new exceptions, please consider making your own custom exception type.  There are times where you may want to log-and-rethrow an exception; we certainly would not want the stack to get logged twice, or get obscured."
  grep -nR 'new Exception()' $SRCDIR | grep -v '.svn'
  exit 1
fi


