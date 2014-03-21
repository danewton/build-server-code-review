#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

ensureArtifactScope "unitils-dbunit" "test"
if [ $? -ne 0 ]; then
  exit 1
fi

ensureArtifactScope "unitils-spring" "test"
if [ $? -ne 0 ]; then
  exit 1
fi


