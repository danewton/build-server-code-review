#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ "$TYPE" == "pom" ]; then
 exit 0
fi

isPulseModule
if [ $? -ne 1 ]; then
 exit 0
fi

ERR_RSLT=$EXIT_ERROR

FAIL_DATE="20140728"
RULE_MSG="[This rule will go from a WARNING to a FAILED for builds on (and after) $FAIL_DATE.]"

isAfter $FAIL_DATE
if [ $? -eq 0 ]; then
  ERR_RSLT=$EXIT_WARN
fi

if [ "$(grep -R '^[^import].*Logger.*class' $(find src/main/java -type f \( -iname *.java -and -not -iwholename .svn \) ) | perl -i -ne '$line=$_;s/.*\/(.*?).java.*\(\s*(.*?).class.*/\1,\2/g; print "mismatched logger : $line" if "$1" ne "$2";' | wc -l)" -ne 0 ]; then
  echo "Please update your class's logger to use the current class rather than some other class. $RULE_MSG"
  grep -R '^[^import].*Logger.*class' $(find src/main/java -type f \( -iname *.java -and -not -iwholename .svn \) ) | perl -i -ne '$line=$_;s/.*\/(.*?).java.*\(\s*(.*?).class.*/\1,\2/g; print "  mismatched logger : $line" if "$1" ne "$2";'
  exit $ERR_RSLT
fi

