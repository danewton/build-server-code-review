#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ $(grep -R 'System.out.println' $SRCDIR | wc -l) -ne 0 ]; then
  echo "Please remove the System.out.println calls from the java source directory, and use a Logger to write to the application logs instead."
  exit 1
fi


