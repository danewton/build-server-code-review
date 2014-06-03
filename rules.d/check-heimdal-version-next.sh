#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

ARTIFACT_ID=$(getPomArtifactId)
if [ "$ARTIFACT_ID" == "heimdall" ]; then
 exit 0
fi

ERR_RSLT=$EXIT_ERROR

FAIL_DATE="20140610"
RULE_MSG="[This rule will go from a WARNING to a FAILED for builds on (and after) $FAIL_DATE.]"

isAfter $FAIL_DATE
if [ $? -eq 0 ]; then
  ERR_RSLT=$EXIT_WARN
fi

minVersion "heimdall" "1.0.6"
if [ $? -ne 0 ]; then
 exit $ERR_RSLT
fi


