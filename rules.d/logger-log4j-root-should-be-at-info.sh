#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ "$TYPE" != "war" ]; then
 exit 0
fi

ERR_RSLT=$EXIT_ERROR

FAIL_DATE="20140522"
RULE_MSG="[This rule will go from a WARNING to a FAILED for builds on (and after) $FAIL_DATE.]"

isAfter $FAIL_DATE
if [ $? -eq 0 ]; then
  ERR_RSLT=$EXIT_WARN
fi

if [ -f "src/main/resources/log4j.properties" ]; then
  if [ $(grep -i 'log4j.rootLogger=INFO' src/main/resources/log4j.properties | wc -l) -ne 1 ]; then
    echo 'Please place the root logger at INFO level : log4j.rootLogger=INFO. See http://en.wikipedia.org/wiki/Log4j regarding category -vs- logger. $RULE_MSG'
    exit $ERR_RSLT
  fi
fi

if [ -f "src/main/resources/log4j.xml" ]; then
  if [ $(cat src/main/resources/log4j.xml  | perl -i -pe 'BEGIN{undef $/;} s/.*(<root>.*?<\/root>).*/\1/smg' | grep -Ei '<level value="info".?/>' | wc -l) -ne 1 ]; then
    echo 'Please place the root logger at INFO level : <level value="info"/>. See http://en.wikipedia.org/wiki/Log4j regarding priority -vs- level. $RULE_MSG'
    exit $ERR_RSLT
  fi
fi

