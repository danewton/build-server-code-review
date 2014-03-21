#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

LIBS_RELEASE_URL="http://artifactory.suddenlink.cequel3.com/artifactory/libs-release-local"
VER=$(getVersion)
ARTID=$(getArtifactId)
GRPID=$(getGroupId | sed 's/\./\//g')
FND=$(curl -s -I $LIBS_RELEASE_URL/$GRPID/$ARTID/$VER/$ARTID-$VER.$TYPE | grep -c 'application/java-archive')

if [ $FND -ne 0 ]; then
 echo "this particular version '$VER' already exists within Artifactory, please bump up your version number within your pom.xml"
 exit 1
fi

