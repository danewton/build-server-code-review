#!/bin/bash

IS_MVN=false
if [ -f "pom.xml" ]; then
 IS_MVN=true
fi

TYPE="jar"
FOUND_TYPE=$(grep 'packaging' pom.xml | sed 's/.*>\(.*\)<.*/\1/g')
if [ "$FOUND_TYPE" != "" ]; then
  TYPE=$FOUND_TYPE
fi;

