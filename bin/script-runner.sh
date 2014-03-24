#!/bin/bash

SCRIPT_DIR=$(dirname $0)
REVIEW_HOME=$SCRIPT_DIR/../

# set -e

SCRIPT_OUT=/tmp/out$$;
TMP_LOG=/tmp/log$$;

if [ -f "$SCRIPT_OUT" ]; then
 rm "$SCRIPT_OUT";
fi

if [ -f "$TMP_LOG" ]; then
 rm "$TMP_LOG";
fi

HEAD_START="$(basename $1)"

$1 $@ >> $SCRIPT_OUT 2>&1;
if [ "$?" -ne 0 ]; then
 printf "%-75s%-15s\n" $HEAD_START "FAILED" >> $TMP_LOG
 echo "1" > $2;
else
 printf "%-75s%-15s\n" $HEAD_START "PASS" >> $TMP_LOG
fi;

cat $TMP_LOG
rm $TMP_LOG

if [ -f "$SCRIPT_OUT" ]; then
 sed 's/^/  >>>> /g' "$SCRIPT_OUT";
 rm "$SCRIPT_OUT"
fi;

