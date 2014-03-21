#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ "$TYPE" != "war" ]; then
 exit 0
fi

if [ $(grep -c "<url-pattern>/healthCheck</url-pattern>" $WEBXML) -eq 0 ]; then
 echo "please add the HealthCheckServlet servlet mapping to the web.xml"
 exit 1
fi


