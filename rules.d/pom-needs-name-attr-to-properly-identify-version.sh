#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ $(grep -c '<name>' pom.xml) -eq 0 ]; then
  echo "please add a <name> element in your pom to help our scripts to properly identify the correct <version> element within your pom.  Preferably, it would be within 4 or 5 lines above your <version> element  (this is a crappy parser, I know)."
  exit 1
fi


