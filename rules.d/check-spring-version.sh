#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

MIN_SPRING_VERSION="2.5.6"
rtn=0

function checkVersion(){
  JAR=$1
  pomHas $JAR
  if [ $? -eq 1 ]; then
    minVersion $JAR $MIN_SPRING_VERSION
    if [ $? -ne 0 ]; then
      rtn=1
    fi
  fi
}

# There is a problem with including the spring-all jar, and then having some other pom entry that then pulls in a different version 
# of say, spring-jdbc.  We need to get away from including the spring-all jar.
checkVersion "spring"
checkVersion "spring-core"
checkVersion "spring-web"
checkVersion "spring-webmvc"
checkVersion "spring-jdbc"
checkVersion "spring-aop"
checkVersion "spring-test"
checkVersion "spring-context"
checkVersion "spring-context-support"
checkVersion "spring-oxm"

exit $rtn
