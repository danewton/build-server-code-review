#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

DESIRED_VERSION="1.0.9"
if [ "$(cat pom.xml | perl -i -pe 'BEGIN{undef $/;} s/<!--.*?-->//smg;s/<build>.*?<\/build>//smg;s/<exclusions>.*?<\/exclusions>//smg;s/<scm>.*?<\/scm>//smg;s/<dependencies>.*?<\/dependencies>//smg;s/<properties>.*?<\/properties>//smg;' | grep -A 2 '<artifactId>parent-pom<' | grep '<version>'  | sed 's/.*>\(.*\)<.*/\1/g')" != "$DESIRED_VERSION" ]; then
 echo "Please bump your parent-pom version up to $DESIRED_VERSION."
 exit 1
fi

