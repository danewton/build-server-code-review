#!/bin/bash

SCRIPT_DIR=$(dirname $0)
REVIEW_HOME=$SCRIPT_DIR/../

# set -e

SCRIPT_OUT=/tmp/out$$;
TMP_LOG=/tmp/log$$;

function cleanLogs(){
 if [ -f "$SCRIPT_OUT" ]; then
  rm "$SCRIPT_OUT";
 fi

 if [ -f "$TMP_LOG" ]; then
  rm "$TMP_LOG";
 fi
}

STATUS_LINE_START="$(basename $1)"

trap "cleanLogs" EXIT

cleanLogs; # start with a clean slate
$1 $@ >> $SCRIPT_OUT 2>&1;
RSLT="$?"
if [ "$RSLT" -eq 4 ]; then
 printf "%-75s%-15s\n" $STATUS_LINE_START "SKIPPING" >> $TMP_LOG
fi;

if [ "$RSLT" -eq 3 ]; then
 printf "%-75s%-15s\n" $STATUS_LINE_START "WARNING" >> $TMP_LOG
fi;

if [ "$RSLT" -eq 1 ]; then
 printf "%-75s%-15s\n" $STATUS_LINE_START "FAILED" >> $TMP_LOG
 # do something to stop the build
 echo "1" > $2;
fi;

if [ "$RSLT" -eq 0 ]; then
 printf "%-75s%-15s\n" $STATUS_LINE_START "PASS" >> $TMP_LOG
fi;

cat $TMP_LOG

if [ -f "$SCRIPT_OUT" ]; then
 sed 's/^/  >>>> /g' "$SCRIPT_OUT";
fi;

