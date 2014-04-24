#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

ensureArtifactScope "hamcrest-all" "test"
if [ $? -ne 0 ]; then
  exit 1
fi

ensureArtifactScope "hamcrest-core" "test"
if [ $? -ne 0 ]; then
  exit 1
fi


