#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ $(grep -R 'System.exit' $SRCDIR | grep -v '.svn' | wc -l) -ne 0 ]; then
  echo "Please remove the System.exit calls from the java source directory."
  grep -nR 'System.exit' $SRCDIR | grep -v '.svn'
  exit 1
fi


