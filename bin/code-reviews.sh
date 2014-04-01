#!/bin/bash

SCRIPT_DIR=$(dirname $0)
REVIEW_HOME=$SCRIPT_DIR/../

# set -e
rtnfile=/tmp/rtn$$

function xargsRunner(){
 SCRIPT_DIR=$1
 TGT=$2
 RTNFILE=$3

 TMP_LOG=/tmp/log$$;
 if [ -f $TMP_LOG ]; then
  rm $TMP_LOG;
 fi;
 $SCRIPT_DIR/script-runner.sh $TGT $RTNFILE $@ >> $TMP_LOG 2>&1;
 cat "$TMP_LOG";
 rm "$TMP_LOG";
}

export -f xargsRunner;

ORIG_ARGS="$@"
find $REVIEW_HOME/rules.d/*.sh | xargs -P 8 -n 1 -I "{}" sh -c "xargsRunner $SCRIPT_DIR {} $rtnfile $ORIG_ARGS"

if [ -f $rtnfile ]; then
  rtn=$(cat $rtnfile)
  rm $rtnfile
else
  rtn=0
fi

if [ $rtn -eq 0 ]; then
  echo "final checks ended with $rtn; SUCCESS"
else
  echo "final checks found code review issues, please resolve and try again."
  exit 1
fi

