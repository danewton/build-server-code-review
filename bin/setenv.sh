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


COMDIR="$(find . -maxdepth 4 -type d -iname 'com' | grep src | grep -vE '(test|resources|webapp)')"
SRCDIR="$(echo $COMDIR | sed 's/\/com//g')"
WEBXML=$(find . -type f -iname 'web.xml' | head -n 1)
WEBLOGICXML=$(find . -type f -iname 'weblogic.xml' | head -n 1)

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

function minVersion(){
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

function getVersion(){
  if [ ! -f "pom.xml" ]; then
    return 0
  fi;
  echo $(grep -C 5 '<name>' pom.xml | grep '<version>' | sed 's/.*>\(.*\)<.*/\1/g')
}

function getArtifactId(){
  if [ ! -f "pom.xml" ]; then
    return 0
  fi;
  echo $(head -n 10 pom.xml | grep '<artifactId>' | sed 's/.*>\(.*\)<.*/\1/g')
}

function getGroupId(){
  if [ ! -f "pom.xml" ]; then
    return 0
  fi;
  echo $(head -n 10 pom.xml | grep '<groupId>' | sed 's/.*>\(.*\)<.*/\1/g')
}

function isRelease(){
  for arg in "$@"; do
    if [ "$arg" == "release:release" ]; then
      echo true
      return 0
    fi;
  done;
  echo false
}

