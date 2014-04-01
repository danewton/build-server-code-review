#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

VER=$(getVersion)
IS_REL_BLD=$(isRelease $@)
IS_SNAPSHOT=$(echo $VER | grep -e '-SNAPSHOT' | wc -l)
if [[ "$IS_REL_BLD" == "true" && $IS_SNAPSHOT -ne 1 ]]; then
 echo "Please bump the version of this pom.xml to a -SNAPSHOT version before trying to run a release plan on it."
 exit 1
fi;
