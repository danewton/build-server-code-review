#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

IS_REL=$(isRelease $@)
if [ "$IS_REL" != "true" ]; then
 exit 0
fi;

SVN_SCM_URL=$(svn info | grep URL | cut -c 6-  | sed 's/\(.*\)\(tags\)\(.*\)/\1/g'  | sed 's/\(.*\)\(trunk\)\(.*\)/\1/g'  | sed 's/\(.*\)\(branches\)\(.*\)/\1/g')

TMP_SVN_OUT=/tmp/svn-out$$

function cleanUp(){
 if [ -f "$TMP_SVN_OUT" ]; then
  rm $TMP_SVN_OUT;
 fi
}

trap "cleanUp" EXIT

svn ls $SVN_SCM_URL > $TMP_SVN_OUT;

if [ "$(grep -c 'branches' $TMP_SVN_OUT)" != 1 ]; then
 echo "Please ensure that the SVN repo has the standard directories of (trunk,tags,branches)."
 exit 1
fi;

if [ "$(grep -c 'tags' $TMP_SVN_OUT)" != 1 ]; then
 echo "Please ensure that the SVN repo has the standard directories of (trunk,tags,branches)."
 exit 1
fi;

