#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ "$TYPE" == "pom" ]; then
 exit 0
fi

ARTIFACT_ID=$(getPomArtifactId)
if [ "$ARTIFACT_ID" == "heimdall" ]; then
 exit 0
fi

ERR_RSLT=$EXIT_ERROR

FAIL_DATE="20141101" # 3 months out
RULE_MSG="[This rule will go from a WARNING to a FAILED for builds on (and after) $FAIL_DATE.]"

isAfter $FAIL_DATE
if [ $? -eq 0 ]; then
  ERR_RSLT=$EXIT_WARN
fi

if [ $(grep -R 'ConfigurationGateway' $SRCDIR | grep -Ev '//.*ConfigurationGateway' | grep -v '.svn' | wc -l) -ne 0 ]; then
  echo "Please replace the 'ConfigurationGateway' calls with Configuration.  ConfigurationGateway is an implementation, and Configuration is an interface.  Any code that depends on the concrete class is like coding to specific features of HashMap or ArrayList, rather than just referencing them as Map or List.  We should be coding to the interface, not the implementation.  If you need to wrap it, then please delegate to another Configuration (please don't extend ConfigurationGateway). $RULE_MSG"
  grep -nR 'ConfigurationGateway' $SRCDIR | grep -Ev '//.*ConfigurationGateway' | grep -v '.svn'
  exit $ERR_RSLT
fi


