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

function version(){
  if [ ! -f "pom.xml" ]; then
    return 0
  fi;
  echo $(grep -A 3 "artifactId>$1" pom.xml | grep 'version' | sed 's/.*>\(.*\)<.*/\1/g')
}


