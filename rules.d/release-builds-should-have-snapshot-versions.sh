#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

VER=$(getVersion)
IS_REL_BLD=$(isRelease $@)
IS_SNAPSHOT=$(echo $VER | grep -e '-SNAPSHOT' | wc -l)
if [[ "$IS_REL_BLD" == "true" && $IS_SNAPSHOT -ne 1 ]]; then
 echo "Please bump the version of this pom.xml to a -SNAPSHOT version before trying to run a release plan on it, found $VER.  Now, it is possible that this script keyed in on the wrong <version> element (and this script does need to be upgraded to use more perl); right now, we're grep'ing for 5 lines around the <name> element, and then using the first <version> element ... a little bit of restructuring of the pom may help ensure that we key in on the correct <version> element."
 exit 1
fi;
