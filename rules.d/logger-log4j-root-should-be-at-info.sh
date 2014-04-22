#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ "$TYPE" != "war" ]; then
 exit 0
fi

if [ -f "src/main/resources/log4j.properties" ]; then
  if [ $(grep -i 'log4j.rootLogger=INFO' src/main/resources/log4j.properties | wc -l) -ne 1 ]; then
    echo 'Please place the root logger at INFO level : log4j.rootLogger=INFO. See http://en.wikipedia.org/wiki/Log4j regarding category -vs- logger.'
    exit 1
  fi
fi

if [ -f "src/main/resources/log4j.xml" ]; then
  if [ $(cat src/main/resources/log4j.xml  | perl -i -pe 'BEGIN{undef $/;} s/.*(<root>.*?<\/root>).*/\1/smg' | grep -Ei '<level value="info".?/>' | wc -l) -ne 1 ]; then
    echo 'Please place the root logger at INFO level : <level value="info"/>. See http://en.wikipedia.org/wiki/Log4j regarding priority -vs- level.'
    exit 1
  fi
fi


