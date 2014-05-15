#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ $(grep -c '<name>' pom.xml) -eq 0 ]; then
  echo "Please add a <name> element in your pom to provide a name for Sonar (sonar.suddenlink.cequel3.com)."
  exit 1
fi


