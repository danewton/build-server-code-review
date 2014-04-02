#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ "$TYPE" == "pom" ]; then
 exit 0
fi

if [ "$WEBINFDIR" == "" ]; then
 exit 0
fi

if [ $(find $WEBINFDIR -type f -iname '*.class' | wc -l) -ne 0 ]; then
  echo "Please remove the compiled class files from the java source directory."
  find $WEBINFDIR -type f -iname '*.class';
  exit 1
fi

