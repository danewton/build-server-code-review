#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

rtn=0

ensureArtifactScope "unitils-dbunit" "test"
if [ $? -ne 0 ]; then
  rtn=1
fi

ensureArtifactScope "unitils-spring" "test"
if [ $? -ne 0 ]; then
  rtn=1
fi

exit $rtn

