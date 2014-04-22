#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ "$TYPE" == "pom" ]; then
 exit 0
fi

ERR_RSLT=$EXIT_ERROR

FAIL_DATE="20140522"
RULE_MSG="[This rule will go from a WARNING to a FAILED for builds on (and after) $FAIL_DATE.]"

isAfter $FAIL_DATE
if [ $? -eq 0 ]; then
  ERR_RSLT=$EXIT_WARN
fi

pomHasNot "spring"
if [ $? -ne 0 ]; then
  echo "Found 'spring' all dependency, please upgrade your pom to include the excplicit spring jars (for example : spring-jdbc, spring-context, or spring-web). $RULE_MSG"
  exit $ERR_RSLT
fi


