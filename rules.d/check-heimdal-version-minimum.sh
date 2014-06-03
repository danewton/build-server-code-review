#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

ARTIFACT_ID=$(getPomArtifactId)
if [ "$ARTIFACT_ID" == "heimdall" ]; then
 exit 0
fi

minVersion "heimdall" "1.0.4"
if [ $? -ne 0 ]; then
 exit 1
fi


