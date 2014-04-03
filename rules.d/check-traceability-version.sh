#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

ARTIFACT_ID=$(getArtifactId)
if [ "$ARTIFACT_ID" == "traceability" ]; then
 exit 0
fi

rtn=0

minVersion "traceability" "1.0.10"
if [ $? -ne 0 ]; then
 rtn=1
fi


exit $rtn

