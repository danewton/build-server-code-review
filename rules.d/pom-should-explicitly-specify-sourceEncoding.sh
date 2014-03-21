#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ $(grep -c '<project.build.sourceEncoding>UTF-8' pom.xml) -eq 0 ]; then
  echo "Please add the following in the <properties> section of your pom : <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>"
  exit 1
fi


