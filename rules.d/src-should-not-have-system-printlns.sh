#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ "$TYPE" == "pom" ]; then
 exit 0
fi

if [ $(grep -R 'System.out.println' $SRCDIR | grep -v '.svn' | wc -l) -ne 0 ]; then
  echo "Please remove the System.out.println calls from the java source directory, and use a Logger to write to the application logs instead."
  grep -nR 'System.out.println' $SRCDIR | grep -v '.svn'
  exit 1
fi


