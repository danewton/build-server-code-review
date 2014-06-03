#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

ERR_RSLT=$EXIT_ERROR

pomHasBoth "slf4j-log4j12" "log4j-over-slf4j" "$RULE_MSG"
if [ $? -eq 1 ]; then
  exit $ERR_RSLT
fi


