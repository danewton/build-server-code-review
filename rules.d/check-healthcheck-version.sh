#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ "$TYPE" != "war" ]; then
 exit 0
fi

ARTIFACT_ID=$(getArtifactId)
if [ "$ARTIFACT_ID" == "healthcheck" ]; then
 exit 0
fi

minVersion "healthcheck-servlet" "1.0.9"
if [ $? -ne 0 ]; then
 exit 1
fi


