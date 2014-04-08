#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ "$TYPE" == "pom" ]; then
 exit 0
fi

if [ "$(grep '%d{' $(find src/main -type f | grep -v '.svn' | egrep '.*log.*(\.xml|\.properties)') | wc -l)" -ne 0 ]; then
  echo "When splunk parses our log files, it needs to know how to parse them - our logging date-pattern is critical to that. We need our dates in the patterns to be in the form of '%d ' (that's percent-d-space), without an explicit date pattern defined."
  grep '%d{' $(find src/main -type f | grep -v '.svn' | egrep '.*log.*(\.xml|\.properties)')
  exit 1
fi

