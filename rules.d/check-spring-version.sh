#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

MIN_SPRING_VERSION="2.5.6"
rtn=0

# There is a problem with including the spring-all jar, and then having some other pom entry that then pulls in a different version 
# of say, spring-jdbc.  We need to get away from including the spring-all jar.
minVersion "spring" $MIN_SPRING_VERSION
if [ $? -ne 0 ]; then
 rtn=1
fi

minVersion "spring-core" $MIN_SPRING_VERSION
if [ $? -ne 0 ]; then
 rtn=1
fi

minVersion "spring-web" $MIN_SPRING_VERSION
if [ $? -ne 0 ]; then
 rtn=1
fi

minVersion "spring-webmvc" $MIN_SPRING_VERSION
if [ $? -ne 0 ]; then
 rtn=1
fi

minVersion "spring-jdbc" $MIN_SPRING_VERSION
if [ $? -ne 0 ]; then
 rtn=1
fi

minVersion "spring-aop" $MIN_SPRING_VERSION
if [ $? -ne 0 ]; then
 rtn=1
fi

minVersion "spring-test" $MIN_SPRING_VERSION
if [ $? -ne 0 ]; then
 rtn=1
fi

minVersion "spring-context-support" $MIN_SPRING_VERSION
if [ $? -ne 0 ]; then
 rtn=1
fi

exit $rtn
