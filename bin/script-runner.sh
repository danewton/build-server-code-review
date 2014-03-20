#!/bin/bash

SCRIPT_DIR=$(dirname $0)
REVIEW_HOME=$SCRIPT_DIR/../

# set -e

SCRIPT_OUT=/tmp/out$$;
TMP_LOG=/tmp/log$$;

echo -n "testing $(basename $1) ... " >> $TMP_LOG
$1 >> $SCRIPT_OUT 2>&1;
if [ "$?" -ne 0 ]; then
 echo "FAILED" >> $TMP_LOG
 echo "1" > $2;
else
 echo "SUCCESS" >> $TMP_LOG
fi;

cat $TMP_LOG
rm $TMP_LOG

if [ -f "$SCRIPT_OUT" ]; then
 sed 's/^/  >>>> /g' "$SCRIPT_OUT";
 rm "$SCRIPT_OUT"
fi;

