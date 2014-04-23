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

if [ $(grep 'compile' dependencies.txt | grep -v 'scope not updated' | perl -i -pe 's/.* .*:(.*):jar:.*:compile/\1/g' | sort | uniq -c | grep -v 1 | wc -l) -ne 0 ]; then
  echo "Please update/correct your dependencies, duplicate jars (with different versions) were found in your build. $RULE_MSG"
  grep 'compile' dependencies.txt | grep -v 'scope not updated' | perl -i -pe 's/.* .*:(.*):jar:.*:compile/\1/g' | sort | uniq -c | grep -v 1
  exit $ERR_RSLT
fi


