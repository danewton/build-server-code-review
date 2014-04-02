#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ "$TYPE" == "pom" ]; then
 exit 0
fi

MSG="Please remove your IDE specific settings from the project, so that other team members don't have to keep fighting with updates/commits simply because they are using a different IDE or a different version of the same IDE.  We would encourage you to use svn-ignores (or something comparable) to avoid checking these files in, in addition to any compiled code."

if [ -d ".settings" ]; then
 echo $MSG
# exit 0
fi

if [ -d ".idea" ]; then
 echo $MSG
# exit 0
fi

if [ -d ".nb" ]; then
 echo $MSG
# exit 0
fi

if [ -d ".gradle" ]; then
 echo $MSG
# exit 0
fi
