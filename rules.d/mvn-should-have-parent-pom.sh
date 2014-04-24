#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ $(cat pom.xml | perl -i -pe 'BEGIN{undef $/;} s/<!--.*?-->//smg;s/<build>.*?<\/build>//smg;s/<exclusions>.*?<\/exclusions>//smg;s/<scm>.*?<\/scm>//smg;s/<dependencies>.*?<\/dependencies>//smg;s/<properties>.*?<\/properties>//smg;' | grep '<artifactId>parent-pom<' | wc -l) -ne 1 ]; then
 echo "Please add the parent-pom section to your pom."
 exit 1
fi

