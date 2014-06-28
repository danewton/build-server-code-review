#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ "$TYPE" == "pom" ]; then
 exit 0
fi

if [ $(grep -R '.printStackTrace()' $SRCDIR | grep -Ev '//.*printStackTrace' | grep -v '.svn' | wc -l) -ne 0 ]; then
  echo "Please replace the .printStackTrace() calls in the java source directory with Logging statements."
  grep -nR '.printStackTrace()' $SRCDIR | grep -Ev '//.*printStackTrace' | grep -v '.svn'
  exit 1
fi


