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

function pomHas(){
  if [ ! -f "pom.xml" ]; then
    return 0
  fi;
  ARTIFACT=$1
  if [ $(grep -c "$ARTIFACT" pom.xml) -eq 0 ]; then
    echo "please add the $ARTIFACT to the pom.xml"
    return 1
  fi
}

function version(){
  if [ ! -f "pom.xml" ]; then
    return 0
  fi;
  ARTIFACT=$1
  MINVER=$2
  VER=$(grep -A 3 "artifactId>$ARTIFACT" pom.xml | grep 'version' | sed 's/.*>\(.*\)<.*/\1/g')
  if [ "$MINVER" != "$VER" ]; then
    echo "please update your $1 from '"$VER"' to $MINVER"
    return 1
  fi
}

