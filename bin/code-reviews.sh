#!/bin/bash

SCRIPT_DIR=$(dirname $0)
REVIEW_HOME=$SCRIPT_DIR/../

# set -e
rtnfile=/tmp/rtn$$

PROC_CNT="8"
RPLCMENT='{}';
SH_CMD='TMP_LOG=/tmp/log$$; '$SCRIPT_DIR'/script-runner.sh {} '$rtnfile' '$@' >> $TMP_LOG 2>&1; cat $TMP_LOG'

find $REVIEW_HOME/rules.d/*.sh | xargs -P $PROC_CNT -n 1 -I "$RPLCMENT" sh -c "$SH_CMD"

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


/opt/soa/adm/products/maven/current/bin/mvn "$@"

