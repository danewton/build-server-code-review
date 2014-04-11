#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ "$TYPE" != "war" ]; then
 exit 0
fi

if [ ! -f "src/main/resources/logback.xml" ]; then
 # this project doesn't hava logback
 exit 0
fi

if [ $(grep -i '<root level="INFO">' src/main/resources/logback.xml | wc -l) -ne 1 ]; then
  echo 'Please place the root logger at INFO level : <root level="INFO">'
  exit 1
fi

