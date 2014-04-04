#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

IS_REL=$(isRelease $@)
if [ "$IS_REL" != "true" ]; then
 exit 0
fi;

CNT=$(cat pom.xml | perl -i -pe 'BEGIN{undef $/;} s/<!--.*?-->//smg;s/<build>.*?<\/build>//smg;s/<exclusions>.*?<\/exclusions>//smg' | grep -e '-SNAPSHOT' | wc -l)

if [ "$CNT" -ge 2 ]; then
 echo "Well, I don't think this build will work. If you're trying to make a release version, there's only enough room for one -SNAPSHOT in this pom.  Please bump your dependencies from -SNAPSHOT versions to release versions."
 exit 1
fi
