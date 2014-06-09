#!/bin/bash

EXIT_GOOD=0
EXIT_ERROR=1
EXIT_WARN=3
DEPENDENCIES_FILE="dependencies.txt"


IS_MVN=false
if [ -f "pom.xml" ]; then
 IS_MVN=true
fi

TYPE="jar"
FOUND_TYPE=$(grep 'packaging' pom.xml | sed 's/.*>\(.*\)<.*/\1/g')
if [ "$FOUND_TYPE" != "" ]; then
  TYPE=$FOUND_TYPE
fi;


COMDIR="$(find . -maxdepth 4 -type d -iname 'com' | grep src | grep -vE '(test|resources|webapp)' | head -n 1)"
SRCDIR="$(echo $COMDIR | sed 's/\/com//g')"
if [ -d 'src/com' ]; then
  SRCDIR="src"
fi
if [ -d 'src/main/java/com' ]; then
  SRCDIR="src/main/java"
fi

WEBXML=$(find . -type f -iname 'web.xml' | head -n 1)
WEBLOGICXML=$(find . -type f -iname 'weblogic.xml' | head -n 1)
WEBINFDIR="$(find . -type d -iname 'WEB-INF' | head -n 1)"
WEBDIR="$WEBINFDIR/.."

function pomHas(){
  if [ ! -f "pom.xml" ]; then
    return 0
  fi;
  ARTIFACT=$1
  if [ $(grep -E "\[.*:$ARTIFACT:" $DEPENDENCIES_FILE | wc -l) -eq 0 ]; then
    return 0
  fi
  return 1
}

function pomHasNot(){
  if [ ! -f "pom.xml" ]; then
    return 0
  fi;
  ARTIFACT=$1
  if [ $(grep -E "\[.*:$ARTIFACT:" $DEPENDENCIES_FILE | wc -l) -ge 1 ]; then
    return 1
  fi
  return 0
}

function getRawVersions(){
  if [ ! -f "pom.xml" ]; then
    return 0
  fi;
  ARTIFACT=$1

  # check to see if the artifact is even in the pom
  if [ $(grep -E "\[.*:$ARTIFACT:" $DEPENDENCIES_FILE | wc -l) -eq 0 ]; then  
    return 0
  fi

  echo $(grep -E "\[.*:$ARTIFACT:" $DEPENDENCIES_FILE | perl -i -pe 's/.*? (.*):(.*):(.*):(.*):(.*) ?.*/\4/g;s/(.*?) .*/\1/g')  
}

function getMajorVersions(){
  if [ ! -f "pom.xml" ]; then
    return 0
  fi;
  ARTIFACT=$1

  # check to see if the artifact is even in the pom
  if [ $(grep -E "\[.*:$ARTIFACT:" $DEPENDENCIES_FILE | wc -l) -eq 0 ]; then  
    return 0
  fi

  VER=$(getRawVersions $ARTIFACT)
  echo $(echo $VER | perl -i -pe 's/(\d*)\..*/\1/g')
}

function minVersion(){
  if [ ! -f "pom.xml" ]; then
    return 0
  fi;
  ARTIFACT=$1
  MINVER=$2
  RULE_MSG=$3

  # check to see if the artifact is even in the pom
  if [ $(grep -E "\[.*:$ARTIFACT:" $DEPENDENCIES_FILE | wc -l) -eq 0 ]; then  
    return 0
  fi

  VERSIONS=$(getRawVersions $ARTIFACT)
  for VER in $VERSIONS
  do
    VER_ORIG="$VER"
    VER=$(echo $VER | sed 's/-SNAPSHOT//g')
    VER=$(echo $VER | sed 's/.RELEASE//g')
    VER=$(echo $VER | sed 's/.GA//g')
  
    MSG="Please update your $ARTIFACT from '"$VER_ORIG"' to '$MINVER' or higher."
    if [ "$RULE_MSG" != "" ]; then
      MSG="$MSG $RULE_MSG"
    fi
  
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
      echo $MSG
      return 1
    fi
  
    MINVER_MIN=$(echo $MINVER | sed 's/\(.*\)\.\(.*\)\.\(.*\)/\2/g')
    ACTVER_MIN=$(echo $VER | sed 's/\(.*\)\.\(.*\)\.\(.*\)/\2/g')
    if [ "$ACTVER_MIN" -gt "$MINVER_MIN" ]; then
      return 0
    fi
    if [ "$ACTVER_MIN" -lt "$MINVER_MIN" ]; then
      echo $MSG
      return 1
    fi
  
    MINVER_PATCH=$(echo $MINVER | sed 's/\(.*\)\.\(.*\)\.\(.*\)/\3/g')
    ACTVER_PATCH=$(echo $VER | sed 's/\(.*\)\.\(.*\)\.\(.*\)/\3/g')
    if [ "$ACTVER_PATCH" -gt "$MINVER_PATCH" ]; then
      return 0
    fi
    if [ "$ACTVER_PATCH" -lt "$MINVER_PATCH" ]; then
      echo $MSG
      return 1
    fi
  done
}

function ensureArtifactScope(){
  if [ ! -f "pom.xml" ]; then
    return 0
  fi;
  ARTIFACT=$1
  DESIRED_SCOPE=$2
  OPTIONAL_SCOPE=$3
  ACTUAL_SCOPES=$(grep -E "\[.*:$1:" $DEPENDENCIES_FILE | perl -i -pe 's/.*? (.*):(.*):(.*):(.*):(.*) ?.*/\5/g;s/(.*?) .*/\1/g')
  if [ "$ACTUAL_SCOPES" == "" ]; then
    # artifact does not explicitly exist for this build
    return 0
  fi
  for ACTUAL_SCOPE in $ACTUAL_SCOPES
  do
    if [ "$ACTUAL_SCOPE" == "$DESIRED_SCOPE" ]; then
      return 0
    fi
    if [[ "$OPTIONAL_SCOPE" != "" && "$ACTUAL_SCOPE" == "$OPTIONAL_SCOPE" ]]; then
      return 0
    fi
  
    MSG="Please change the scope of '$ARTIFACT' from '$ACTUAL_SCOPE' to '$DESIRED_SCOPE'"
    if [ "$OPTIONAL_SCOPE" != "" ]; then
      MSG="$MSG or '$OPTIONAL_SCOPE'"
    fi
    echo $MSG
    return 1
  done
}

function getPomVersion(){
  if [ ! -f "pom.xml" ]; then
    return 0
  fi;
  echo $(cat pom.xml | perl -i -pe 'BEGIN{undef $/;} s/<!--.*?-->//smg;s/<build>.*?<\/build>//smg;s/<dependencies>.*?<\/dependencies>//smg;;s/<parent>.*?<\/parent>//smg;s/<scm>.*?<\/scm>//smg' | grep '<version>' | sed 's/.*>\(.*\)<.*/\1/g')
}

function getPomArtifactId(){
  if [ ! -f "pom.xml" ]; then
    return 0
  fi;
  echo $(cat pom.xml | perl -i -pe 'BEGIN{undef $/;} s/<!--.*?-->//smg;s/<build>.*?<\/build>//smg;s/<dependencies>.*?<\/dependencies>//smg;;s/<parent>.*?<\/parent>//smg;s/<scm>.*?<\/scm>//smg' | grep '<artifactId>' | sed 's/.*>\(.*\)<.*/\1/g')
}

function getPomGroupId(){
  if [ ! -f "pom.xml" ]; then
    return 0
  fi;
  echo $(cat pom.xml | perl -i -pe 'BEGIN{undef $/;} s/<!--.*?-->//smg;s/<build>.*?<\/build>//smg;s/<dependencies>.*?<\/dependencies>//smg;;s/<parent>.*?<\/parent>//smg;s/<scm>.*?<\/scm>//smg' | grep '<groupId>' | sed 's/.*>\(.*\)<.*/\1/g')
}

function getPomSCM(){
  if [ ! -f "pom.xml" ]; then
    return 0
  fi;
  echo $(grep -A 3 '<scm>' pom.xml | grep '<url>' | sed 's/.*>\(.*\)<.*/\1/g' | sed 's/\(.*\)\(tags\)\(.*\)/\1/g'  | sed 's/\(.*\)\(trunk\)\(.*\)/\1/g'  | sed 's/\(.*\)\(branches\)\(.*\)/\1/g')
}

function isRelease(){
  for arg in "$@"; do
    if [ "$arg" == "release:perform" ]; then
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

TODAY="$(date +%Y%m%d)"
function isAfter(){
  if [ $TODAY -ge $1 ]; then
    return 1
  fi;
  return 0
}

function pomHasBoth(){
  if [ ! -f "pom.xml" ]; then
    return 0
  fi;
  ARTIFACT_1=$1
  ARTIFACT_2=$2
  EXTRA_MSG=$3
  if [[ $(grep -E "\[.*:$ARTIFACT_1:" $DEPENDENCIES_FILE | wc -l) -ge 1 && $(grep -E "\[.*:$ARTIFACT_2:" $DEPENDENCIES_FILE | wc -l) -ge 1 ]]; then
    MSG="Found both $ARTIFACT_1 and $ARTIFACT_2 in your build. Please resolve your dependencies."
    if [ "$EXTRA_MSG" != "" ]; then
      MSG="$MSG $EXTRA_MSG"
    fi
    echo $MSG
    return 1
  fi
}


