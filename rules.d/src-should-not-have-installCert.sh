#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [[ "$TYPE" != "war" && "$TYPE" != "jar" ]]; then
 exit 0
fi

if [ $(find $SRCDIR -type f -iname 'InstallCert.java' | wc -l) -ne 0 ]; then
  echo "please remove the InstallCert.java class from the java source directory."
  exit 1
fi


