#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ "$TYPE" != "war" ]; then
 exit 0
fi

isPulseModule
if [ $? -ne 1 ]; then
 exit 0
fi

if [ $(grep -c "<servlet-class>com.suddenlink.util.HealthCheckServlet</servlet-class>" $WEBXML) -eq 0 ]; then
 echo "please add the HealthCheckServlet to the web.xml"
 exit 1
fi


