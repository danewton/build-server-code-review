#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ $(grep -R 'System.println' $SRCDIR | wc -l) -ne 0 ]; then
  echo "please remove the System.println calls from the java source directory."
  exit 1
fi


