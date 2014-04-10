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

LB_LOG="$(grep '<file>' src/main/resources/logback.xml | head -n 1 | sed 's/.*>\(.*\)<.*/\1/')"

if [ $(echo "$LB_LOG" | grep -cE  "/var/log/applications/(custcare|marketing|provisioning|programming)/apps/.*\.log") -ne 1 ]; then
  echo "The name of the log file in the <file> needs to match '/var/log/applications/(custcare|marketing|provisioning|programming)/apps/.*\.log'"
  echo "found $(grep '<file>' src/main/resources/logback.xml | head -n 1)" 
  exit 1
fi

