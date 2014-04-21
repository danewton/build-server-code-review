#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ -f "src/main/java/log4j.properties" ]; then
  echo 'A logging configuration file was found under src/main/java, please relocate it to an appropriate location.  Usually this would be under src/main/resources or under src/test/resources.'
  exit 1
fi

if [ -f "src/main/java/log4j.xml" ]; then
  echo 'A logging configuration file was found under src/main/java, please relocate it to an appropriate location.  Usually this would be under src/main/resources or under src/test/resources.'
  exit 1
fi

if [ -f "src/main/java/logback.xml" ]; then
  echo 'A logging configuration file was found under src/main/java, please relocate it to an appropriate location.  Usually this would be under src/main/resources or under src/test/resources.'
  exit 1
fi



