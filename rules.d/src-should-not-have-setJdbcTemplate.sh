#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ "$TYPE" == "pom" ]; then
 exit 0
fi

ERR_RSLT=$EXIT_ERROR

FAIL_DATE="20140722"
RULE_MSG="[This rule will go from a WARNING to a FAILED for builds on (and after) $FAIL_DATE.]"

isAfter $FAIL_DATE
if [ $? -eq 0 ]; then
  ERR_RSLT=$EXIT_WARN
fi

if [ $(grep -R 'setJdbcTemplate(' $SRCDIR | grep -v '.svn' | wc -l) -ne 0 ]; then
  echo "Please replace your setJdbcTemplate methods with setJdbcOperations.  JdbcTemplate is an implementation, and JdbcOperations is an interface. Any code that says setJdbcTemplate is like saying setHashMap or setArrayList, rather than saying setMap or setList.  We need our method signatures to be coded to interfaces, not to implementations. $RULE_MSG"
  grep -nR 'setJdbcTemplate(' $SRCDIR | grep -v '.svn'
  exit $ERR_RSLT
fi


