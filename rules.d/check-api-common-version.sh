#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

ERR_RSLT=$EXIT_ERROR

FAIL_DATE="20140615"
RULE_MSG="[This rule will go from a WARNING to a FAILED for builds on (and after) $FAIL_DATE.]"

isAfter $FAIL_DATE
if [ $? -eq 0 ]; then
  ERR_RSLT=$EXIT_WARN
fi

minVersion "api-common" "1.6.10" "$RULE_MSG"
if [ $? -ne 0 ]; then
 exit $ERR_RSLT
fi


