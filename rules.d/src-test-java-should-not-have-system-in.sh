#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ "$TYPE" == "pom" ]; then
 exit 0
fi

if [ $(grep -R 'System.in' $SRCDIR | grep -v '.svn' | wc -l) -ne 0 ]; then
  echo "Please remove the System.in calls from the src/test/java source directory."
  grep -nR 'System.in' $SRCDIR | grep -v '.svn'
  exit 1
fi


