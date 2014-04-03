#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ "$TYPE" == "pom" ]; then
 exit 0
fi

LOGBACK_MAX_HIST="$(grep 'maxHistory' $(find src/main -type f | grep -v '.svn' | egrep '.*logback.xml') | head -n 1 | sed 's/.*>\(.*\)<.*/\1/g')"
if [[ "$LOGBACK_MAX_HIST" != "" && "$LOGBACK_MAX_HIST" -gt "10" ]]; then
  echo "Please update your logback config to keep no more than 10 rolled history files (value found : $LOGBACK_MAX_HIST)."
  exit 1
fi

LOG4J_MAX_HIST="$(grep 'MaxBackupIndex' $(find src/main -type f | grep -v '.svn' | egrep '.*log4j.properties') | egrep -v '^#' | head -n 1 | cut -d= -f2)"
if [[ "$LOG4J_MAX_HIST" != "" && "$LOG4J_MAX_HIST" -gt "10" ]]; then
  echo "Please update your log4j config to keep no more than 10 rolled history files (value found : $LOG4J_MAX_HIST)."
  exit 1
fi

LOG4J_MAX_HIST="$(grep 'MaxBackupIndex' $(find src/main -type f | grep -v '.svn' | egrep '.*log4j.xml') | sed 's/.*value="\([0-9]*\)".*/\1/g' | head -n 1)"
if [[ "$LOG4J_MAX_HIST" != "" && "$LOG4J_MAX_HIST" -gt "10" ]]; then
  echo "Please update your log4j config to keep no more than 10 rolled history files (value found : $LOG4J_MAX_HIST)."
  exit 1
fi

