#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

ensureArtifactScope "dbunit" "test"
if [ $? -ne 0 ]; then
  exit 1
fi


