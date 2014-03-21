#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

IS_REL=$(isRelease "$@")
if [ "$IS_REL" != "true" ]; then
 exit 0
fi;

POM_SCM_URL=$(getPomSCM)
SVN_SCM_URL=$(svn info | grep URL | cut -c 6-  | sed 's/\(.*\)\(tags\)\(.*\)/\1/g'  | sed 's/\(.*\)\(trunk\)\(.*\)/\1/g'  | sed 's/\(.*\)\(branches\)\(.*\)/\1/g')
if [ "$SVN_SCM_URL" != "$POM_SCM_URL" ]; then
 echo "svn : $SVN_SCM_URL"
 echo "pom : $POM_SCM_URL"
 echo "The SCM/SVN url from the checkout does not match the SCM/SVN url that's in the POM.  Please add or correct it, so that the mvn release:release plan can properly tag the project."
 exit 1
fi
