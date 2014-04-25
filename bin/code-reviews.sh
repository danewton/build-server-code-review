#!/bin/bash

SCRIPT_DIR=$(dirname $0)
REVIEW_HOME=$SCRIPT_DIR/../

# set -e
rtnfile=/tmp/rtn$$
emailBody=/tmp/email$$

function xargsRunner(){
 SCRIPT_DIR=$1
 TGT=$2
 RTNFILE=$3
 EMAIL_BODY=$4

 TMP_LOG=/tmp/log$$;
 $SCRIPT_DIR/script-runner.sh $TGT $RTNFILE $@ > $TMP_LOG 2>&1;
 cat "$TMP_LOG" | tee -a $EMAIL_BODY;
 rm "$TMP_LOG";
}

export -f xargsRunner;

ORIG_ARGS="$@"
find $REVIEW_HOME/rules.d/*.sh | xargs -P 8 -n 1 -I "{}" sh -c "xargsRunner $SCRIPT_DIR {} $rtnfile $emailBody $ORIG_ARGS"

HAS_ERRORS=0
HAS_WARNINGS=0
if [ -f $rtnfile ]; then
  HAS_ERRORS=$(grep -c '1' $rtnfile)
  HAS_WARNINGS=$(grep -c '3' $rtnfile)
  rm $rtnfile
fi

function emailWarnings(){
  LAST_COMMITTER=$(svn info | grep Author: | perl -i -pe 's/.*: (.*)/\1/g' | grep '\.')
  PROJECT="$(svn info | grep URL: | cut -d' ' -f2)"
  REVISION="$(svn info | grep Revision: | cut -d' ' -f2)"
  if [ "$LAST_COMMITTER" == "" ]; then
    echo "no valid last committer found; not sending email."
    return
  fi
  if [ "$(hostname)" != "sdldalpladm05.suddenlink.cequel3.com" ]; then
    echo "hostname is not from the build server, not sending an email; found $(hostname)."
    return
  fi
  cat $emailBody | grep -v 'PASS' | mail -s "WARNINGS found during build for $PROJECT:$REVISION" $LAST_COMMITTER@Suddenlink.com
}

function cleanupEmailBody(){
  if [ -f "$emailBody" ]; then
    rm "$emailBody";
  fi
}

if [ "$HAS_ERRORS" -ge 1 ]; then
  echo "final checks found code review issues, please resolve and try again."
  cleanupEmailBody
  # bamboo would send out the email
  exit 1
fi

if [ "$HAS_WARNINGS" -ge 1 ]; then
  echo "final checks found code review WARNINGS, please review them for any time-sensitive issues."
  emailWarnings
  cleanupEmailBody
  exit 0
fi

echo "final checks ended with SUCCESS"
cleanupEmailBody
exit 0



