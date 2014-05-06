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

if [ $(grep -ER '(private|protected)\s*(Simple|NamedParameter)?JdbcTemplate' $SRCDIR | grep -v '.svn' | wc -l) -ne 0 ]; then
  echo "Please replace your JdbcTemplate variable types with JdbcOperations.  JdbcTemplate is an implementation, and JdbcOperations is an interface. Any code that says JdbcTemplate is like saying HashMap or ArrayList, rather than saying Map or List.  We need to code to interfaces, not to implementations. Also see SimpleJdbcOperations and NamedParameterJdbcOperations. $RULE_MSG"
  grep -nER '(private|protected)\s*(Simple|NamedParameter)?JdbcTemplate' $SRCDIR | grep -v '.svn'
  exit $ERR_RSLT
fi


