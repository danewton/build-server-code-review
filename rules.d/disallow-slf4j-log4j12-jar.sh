#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ "$TYPE" == "pom" ]; then
 exit 0
fi

ERR_RSLT=$EXIT_ERROR

FAIL_DATE="20140903"
RULE_MSG="[This rule will go from a WARNING to a FAILED for builds on (and after) $FAIL_DATE.]"

isAfter $FAIL_DATE
if [ $? -eq 0 ]; then
  ERR_RSLT=$EXIT_WARN
fi

pomHasNot "slfj4-log4j12"
if [ $? -ne 0 ]; then
  echo "Found 'slf4j-log4j12' dependency, please update your pom to fall inline with the team standards (see the top-left diagram on http://www.slf4j.org/legacy.html). $RULE_MSG"
  exit $ERR_RSLT
fi


