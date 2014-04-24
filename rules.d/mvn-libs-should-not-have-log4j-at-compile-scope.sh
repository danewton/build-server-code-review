#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [[ "$TYPE" == "war" || "$TYPE" == "ear" || "$TYPE" == "pom" ]]; then
 exit 0
fi

ERR_RSLT=$EXIT_ERROR

FAIL_DATE="20140524"
RULE_MSG="[This rule will go from a WARNING to a FAILED for builds on (and after) $FAIL_DATE.]"

isAfter $FAIL_DATE
if [ $? -eq 0 ]; then
  ERR_RSLT=$EXIT_WARN
fi

ensureArtifactScope "log4j" "test" "provided"
if [ $? -eq 1 ]; then
  echo "A lib/jar should not be explictly dictating the logging implementation.  Please mark 'log4j' as test or provided inside jars; you are also encouraged to utilize a logging api within your lib, such as slf4j. $RULE_MSG"
  exit $ERR_RSLT
fi


