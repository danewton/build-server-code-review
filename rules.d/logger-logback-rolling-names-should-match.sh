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

if [[ $(grep "<fileNamePattern>$LB_LOG.%d</fileNamePattern>" src/main/resources/logback.xml | wc -l) -ne 1 && $(grep "<fileNamePattern>$LB_LOG.%d{yyyy-MM-dd}</fileNamePattern>" src/main/resources/logback.xml | wc -l) -ne 1 ]]; then
  echo "The name of the log file in the <file> needs to match the name in the <fileNamePattern> plus '.%d'.  Please try <fileNamePattern>$LB_LOG.%d</fileNamePattern>, or with %d{yyyy-MM-dd}"
  echo "found $(grep '<fileNamePattern>' src/main/resources/logback.xml | head -n 1)" 
  exit 1
fi

