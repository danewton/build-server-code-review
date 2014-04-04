#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ "$TYPE" == "pom" ]; then
 exit 0
fi

TEST_DIR="src/test"
if [ ! -d "src/test" ]; then
 exit 0
fi

if [ $(grep -R '.printStackTrace()' $TEST_DIR | grep -v '.svn' | wc -l) -ne 0 ]; then
  echo "Please replace the .printStackTrace() calls from the src/test directory with a logging statements.  If your unit test fails, it'll log to the bamboo log files. and honestly, I don't want to see stack traces from your app within my Bamboo server logs. Besides, if you're in a unit test, and within testing code, inside methods that areen't trying to do too much, then why would you ever need to print the stack from that? If you find that it's really easy to type out some keyboard-shortcut that gives you a System.out.println, then it also stands to reason that you would find a good time saving opportunity by adding/finding a keyboard-shortcut for your common logging statements (to include the declaration of the Logger)."
  grep -nR '.printStackTrace()' $TEST_DIR | grep -v '.svn'
  exit 3
fi


