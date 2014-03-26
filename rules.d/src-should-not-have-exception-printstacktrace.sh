#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ "$TYPE" == "pom" ]; then
 exit 0
fi

if [ $(grep -R '.printStackTrace()' $SRCDIR | grep -v '.svn' | wc -l) -ne 0 ]; then
  echo "Please remove the .printStackTrace() calls from the java source directory."
  grep -nR '.printStackTrace()' $SRCDIR | grep -v '.svn'
  exit 1
fi


