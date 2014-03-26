#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ "$TYPE" == "pom" ]; then
 exit 0
fi

if [ $(grep -R 'System.setPropert' $SRCDIR | wc -l) -ne 0 ]; then
  echo "please remove the System.setProperty calls from the java source directory."
  exit 1
fi


