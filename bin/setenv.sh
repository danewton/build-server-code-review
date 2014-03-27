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
  if [ $(grep -c "<artifactId>$ARTIFACT</artifactId>" pom.xml) -eq 0 ]; then
    echo "please add the '$ARTIFACT' to the pom.xml"
    return 1
  fi
}

function pomHasNot(){
  if [ ! -f "pom.xml" ]; then
    return 0
  fi;
  ARTIFACT=$1
  if [ $(grep -c "<artifactId>$ARTIFACT</artifactId>" pom.xml) -ge 1 ]; then
    echo "please remove/upgrade the '$ARTIFACT' in the pom.xml"
    return 1
  fi
}

function minVersion(){
  if [ ! -f "pom.xml" ]; then
    return 0
  fi;
  ARTIFACT=$1
  MINVER=$2

  # check to see if the artifact is even in the pom
  if [ $(grep -C 2 "artifactId>$ARTIFACT" pom.xml | grep -c -C 2 "version") -eq 0 ]; then
    return 0
  fi

  VER=$(grep -A 3 "artifactId>$ARTIFACT" pom.xml | grep -C 2 "version" | grep 'version' | sed 's/.*>\(.*\)<.*/\1/g' | head -n 1)
  # if VER is a property, go find its value
  if [ $(echo "$VER" | grep -c '\$') -ne 0 ]; then
    VER=$(echo $VER | sed 's/\${\(.*\)}/\1/g')
    VER=$(grep "<$VER>" pom.xml | grep -v '<!--' | sed 's/.*>\(.*\)<.*/\1/g')
  fi
  VER_ORIG="$VER"
  VER=$(echo $VER | sed 's/.RELEASE//g')
  VER=$(echo $VER | sed 's/.GA//g')

  # fix for 2 numbers, as it junit 4.4
  if [ $(echo "$MINVER" | grep -o "\." | wc -l) -eq 1 ]; then
    MINVER="$MINVER.0"
  fi
  if [ $(echo "$VER" | grep -o "\." | wc -l) -eq 1 ]; then
    VER="$VER.0"
  fi
 
  MINVER_MAJ=$(echo $MINVER | sed 's/\(.*\)\.\(.*\)\.\(.*\)/\1/g')
  ACTVER_MAJ=$(echo $VER | sed 's/\(.*\)\.\(.*\)\.\(.*\)/\1/g')
  if [ "$ACTVER_MAJ" -gt "$MINVER_MAJ" ]; then
    return 0
  fi
  if [ "$ACTVER_MAJ" -lt "$MINVER_MAJ" ]; then
    echo "please update your $ARTIFACT from '"$VER_ORIG"' to '$MINVER' or higher."
    return 1
  fi

  MINVER_MIN=$(echo $MINVER | sed 's/\(.*\)\.\(.*\)\.\(.*\)/\2/g')
  ACTVER_MIN=$(echo $VER | sed 's/\(.*\)\.\(.*\)\.\(.*\)/\2/g')
  if [ "$ACTVER_MIN" -gt "$MINVER_MIN" ]; then
    return 0
  fi
  if [ "$ACTVER_MIN" -lt "$MINVER_MIN" ]; then
    echo "please update your $ARTIFACT from '"$VER_ORIG"' to '$MINVER' or higher."
    return 1
  fi

  MINVER_PATCH=$(echo $MINVER | sed 's/\(.*\)\.\(.*\)\.\(.*\)/\3/g')
  ACTVER_PATCH=$(echo $VER | sed 's/\(.*\)\.\(.*\)\.\(.*\)/\3/g')
  if [ "$ACTVER_PATCH" -gt "$MINVER_PATCH" ]; then
    return 0
  fi
  if [ "$ACTVER_PATCH" -lt "$MINVER_PATCH" ]; then
    echo "please update your $ARTIFACT from '"$VER_ORIG"' to '$MINVER' or higher."
    return 1
  fi
}

function ensureArtifactScope(){
  if [ ! -f "pom.xml" ]; then
    return 0
  fi;
  ARTIFACT=$1
  DESIRED_SCOPE=$2
  OPTIONAL_SCOPE=$3
  ACTUAL_SCOPE=$(grep -A 3 "<artifactId>$ARTIFACT" pom.xml | grep '<scope>'  | sed 's/.*>\(.*\)<.*/\1/g')
  if [ $(grep -A 2 "<artifactId>$ARTIFACT" pom.xml | grep '<version>' | wc -l) -eq 0 ]; then
    # artifact does not explicitly exist in the pom
    return 0
  fi
  if [ "$ACTUAL_SCOPE" == "$DESIRED_SCOPE" ]; then
    return 0
  fi
  if [ "$ACTUAL_SCOPE" == "$OPTIONAL_SCOPE" ]; then
    return 0
  fi

  MSG="Please change the scope of '$ARTIFACT' from '$ACTUAL_SCOPE' to '$DESIRED_SCOPE'"
  if [ "$OPTIONAL_SCOPE" != "" ]; then
    MSG="$MSG or '$OPTIONAL_SCOPE'"
  fi
  echo $MSG
  return 1
}

function getVersion(){
  if [ ! -f "pom.xml" ]; then
    return 0
  fi;
  echo $(grep -C 5 '<name>' pom.xml | grep '<version>' | head -n 1 | sed 's/.*>\(.*\)<.*/\1/g')
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

function getPomSCM(){
  if [ ! -f "pom.xml" ]; then
    return 0
  fi;
  echo $(grep -A 3 '<scm>' pom.xml | grep '<url>' | sed 's/.*>\(.*\)<.*/\1/g' | sed 's/\(.*\)\(tags\)\(.*\)/\1/g'  | sed 's/\(.*\)\(trunk\)\(.*\)/\1/g'  | sed 's/\(.*\)\(branches\)\(.*\)/\1/g')
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

function isPulseModule(){
  if [ $(svn info | grep https://svn.suddenlink.cequel3.com/svn/pulse | wc -l) -ne 0 ]; then
    return 0
  fi
  return 1
}

isPulseModule
if [ $? -ne 1 ]; then
 echo "This is a Pulse module, skipping checks for now."
 exit 0
fi
