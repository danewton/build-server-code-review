#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ "$TYPE" == "pom" ]; then
 exit 0
fi

if [ "$(grep '.log</fileNamePattern>' $(find src/main -type f | grep -v '.svn' | egrep '.*log.*(\.xml|\.properties)') | wc -l)" -ne 0 ]; then
  echo "When the logs roll, we don't want splunk to pick them up again.  We have scripts on the servers that will clean up old log files if they are beyond a certain age, and they end with \*.log.201\* ... (i.e. foo-ws.log.2014-04-03)"
  grep '.log</fileNamePattern>' $(find src/main -type f | grep -v '.svn' | egrep '.*log.*(\.xml|\.properties)')
  exit 1
fi

